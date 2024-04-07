import os
import clip
import transformers
from multilingual_clip import pt_multilingual_clip
from transformers import LlavaNextProcessor, LlavaNextForConditionalGeneration

import torch
import json
import time

import clickhouse_connect
import redis
from loguru import logger

from PIL import Image as Im

import ruclip

from rsmq.rsmq import RedisSMQ

import boto3

from click_api.utils.click_client import NeighborFinder
from queue_processor import get_bytes_image, pop_from_queue

from models.models import RuClipEmbedder, LLAVA, RobertaClipEmbedder

from dotenv import load_dotenv

max_tags = 5


def main(s3, embedder: RuClipEmbedder, finder: NeighborFinder, llava: LLAVA, rsmq: RedisSMQ):
    while True:
        queue_request = pop_from_queue('upload-analyze-ml', rsmq)
        if queue_request:
            torch.cuda.empty_cache()
            logger.debug('Got request')
            start_time = time.time()
            queue_request = json.loads(queue_request['message'])
            try:
                logger.debug('getting image embedding')
                bytes_image = get_bytes_image(queue_request['filename'], s3)
                pil_image = Im.open(bytes_image)
                image_embedding = embedder.get_image_embeddings([pil_image]).squeeze()
                similar_set = finder.is_similar_image(image_embedding.tolist(), 0.0)
                if len(similar_set) > 0 and not queue_request['force']:
                    similar_filename = similar_set[0][0]
                    rsmq.client.set(f"images:upload:error:{queue_request['filename']}",
                                    json.dumps(obj={'error': 'dublicate',
                                                    'dublicate_filename': similar_filename},
                                               ensure_ascii=False),
                                    ex=60 * 5)
                    continue
                tags = finder.get_tags(image_embedding.tolist(),
                                       k=queue_request['max_tags'] if 'max_tags' in queue_request else max_tags)
                metainfo = llava.describe_image(pil_image)

                if metainfo['landmark'] == "None":
                    metainfo['landmark'] = None

                if isinstance(metainfo['grayscale'], str) and metainfo['grayscale'].isnumeric():
                    metainfo['grayscale'] = int(metainfo['grayscale'])

                metainfo['grayscale'] = bool(metainfo['grayscale'])

                if isinstance(metainfo['number_of_people'], str) and metainfo['number_of_people'].isnumeric():
                    metainfo['number_of_people'] = int(metainfo['number_of_people'])

                for key in metainfo:
                    if isinstance(metainfo[key], str):
                        metainfo[key] = metainfo[key].lower()

                sizes = pil_image.size
                size_proportion = sizes[0] / sizes[1]
                if size_proportion < 1:
                    metainfo['orientation'] = 'вертикальная'
                elif size_proportion > 1:
                    metainfo['orientation'] = 'горизонтальная'
                elif size_proportion == 1:
                    metainfo['orientation'] = 'квадратная'

                out_dict = {'filename': queue_request['filename'], 'tags': tags}
                out_dict.update(metainfo)
                logger.debug(
                    f"Got metadata and tags for {queue_request['filename']} in {round(time.time() - start_time, 3)} seconds")
                rsmq.client.set(f"images:upload:ready:{queue_request['filename']}",
                                json.dumps(out_dict, ensure_ascii=False),
                                ex=60 * 5)
            except Exception as e:
                redis_client.set(f'images:upload:error',
                                 json.dumps(obj={'error': 'error',
                                                 'dublicate_filename': None},
                                            ensure_ascii=False),
                                 ex=60 * 5)
                logger.exception(e)
                continue


if __name__ == "__main__":
    load_dotenv()
    torch.cuda.empty_cache()
    session = boto3.session.Session()
    s3 = session.client(service_name='s3',
                        endpoint_url=os.environ.get('S3_HOST'),
                        aws_access_key_id=os.environ.get('S3_ID'),
                        aws_secret_access_key=os.environ.get('S3_KEY'))

    logger.debug('S3 loaded')

    text_model = pt_multilingual_clip.MultilingualCLIP.from_pretrained('M-CLIP/XLM-Roberta-Large-Vit-L-14')
    text_model.to('cuda')
    tokenizer = transformers.AutoTokenizer.from_pretrained('M-CLIP/XLM-Roberta-Large-Vit-L-14')

    clip_model, clip_preprocess = clip.load("ViT-L/14", device='cuda')
    embedder = RobertaClipEmbedder(clip_model=clip_model,
                                   image_preprocessor=clip_preprocess,
                                   text_model=text_model,
                                   text_preprocessor=tokenizer,
                                   device='cuda')
    logger.debug('Clip loaded')

    llava_processor = LlavaNextProcessor.from_pretrained("llava-hf/llava-v1.6-mistral-7b-hf")
    llava_model = LlavaNextForConditionalGeneration.from_pretrained("llava-hf/llava-v1.6-mistral-7b-hf",
                                                                    torch_dtype=torch.float16,
                                                                    low_cpu_mem_usage=True)
    llava_model.to("cuda:0")
    llava = LLAVA(model=llava_model, processor=llava_processor)
    logger.debug('LLAVA loaded')

    client = clickhouse_connect.get_client(host=os.environ.get('DB_HOST'),
                                           port=int(os.environ.get('DB_PORT')),
                                           user=os.environ.get('DB_USER'),
                                           database=os.environ.get('DB'),
                                           password=os.environ.get('DB_PASSWORD'))
    finder = NeighborFinder(client)
    logger.debug('Clickhouse loaded')

    redis_client = redis.Redis.from_url(os.environ.get("REDIS_URL"))
    rsmq = RedisSMQ(client=redis_client)
    logger.debug('Redis loaded')
    main(s3, embedder, finder, llava, rsmq)
