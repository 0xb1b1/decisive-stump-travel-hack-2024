import json
import os
import clip
import time
from typing import Union, List
import torch

import boto3
import clickhouse_connect
import redis
import ruclip
import transformers
from dotenv import load_dotenv
from fastapi import FastAPI
from fastapi.encoders import jsonable_encoder
from multilingual_clip import pt_multilingual_clip
from rsmq import RedisSMQ

from PIL import Image as Im
from starlette.responses import JSONResponse

from models.models import RuClipEmbedder, RobertaClipEmbedder
from click_api.utils.models import Filters
from queue_processor import get_bytes_image

from loguru import logger

from click_api.utils.click_client import NeighborFinder

load_dotenv()

info_table = '''(with tag_label as
                    (with tag_im as (
                        select * 
                        from images
                        left join tags 
                        on images.filename=tags.filename) 
                    select * 
                    from tag_im 
                    left join labels 
                    on tag_im.filename=labels.filename) 
                select * from tag_label
                left join metas 
                on tag_label.filename=metas.filename)'''

text_info_table = '''(with tag_label as
                    (with tag_im as (
                        select * 
                        from labels
                        left join tags 
                        on labels.filename=tags.filename) 
                    select * 
                    from tag_im 
                    left join images 
                    on tag_im.filename=images.filename) 
                select * from tag_label
                left join metas 
                on tag_label.filename=metas.filename)'''

session = boto3.session.Session()
s3 = session.client(service_name='s3',
                    endpoint_url=os.environ.get('S3_HOST'),
                    aws_access_key_id=os.environ.get('S3_ID'),
                    aws_secret_access_key=os.environ.get('S3_KEY'))

logger.debug('S3 loaded')

text_model = pt_multilingual_clip.MultilingualCLIP.from_pretrained('M-CLIP/XLM-Roberta-Large-Vit-L-14')
text_model.to('cpu')
tokenizer = transformers.AutoTokenizer.from_pretrained('M-CLIP/XLM-Roberta-Large-Vit-L-14')

clip_model, clip_preprocess = clip.load("ViT-L/14", device='cpu')
embedder = RobertaClipEmbedder(clip_model=clip_model,
                               image_preprocessor=clip_preprocess,
                               text_model=text_model,
                               text_preprocessor=tokenizer,
                               device='cpu')
logger.debug('Clip loaded')

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

app = FastAPI()


def get_search_neighbors(embedding, nk, tk, finder, filters, table, fields):
    return {'images': finder.get_search_neighbors(embedding=embedding,
                                                  k=nk, filters=filters,
                                                  table=table,
                                                  fields=fields),
            'tags': finder.get_tags(embedding, k=tk)}


def get_neighbors(table, fields, text=None, filename=None, neighbors_num=20, tags_num=5, filters=None):
    embedding = None
    start_time = time.time()
    if text is not None:
        text = [text]
        embedding = embedder.get_text_embeddings(text).mean(0).tolist()
    if filename is not None:
        bytes_image = get_bytes_image(filename, s3, bucket='images-tmp')
        pil_image = Im.open(bytes_image)
        embedding = embedder.get_image_embeddings([pil_image]).squeeze().tolist()
    logger.debug(f'Got embeddings in {round(time.time() - start_time, 3)} seconds')

    if embedding is not None:
        neighbors = get_search_neighbors(embedding,
                                         neighbors_num,
                                         tags_num, finder, filters, table, fields)
        logger.debug(f"Found {len(neighbors['images'])} neighbors and "
                     f"{len(neighbors['tags'])} tags for {filename if filename is not None else text[0]}")
        return neighbors


@app.post('/search/text/')
async def get_text_neighbors(text: str, neighbors_limit: int = 20, tags_limit: int = 5,
                             filters: Union[Filters, None] = None,
                             fields: Union[List['str'], None] = None):
    if fields is None:
        fields = ['filename', 'tags', 'label']
    neighbors = get_neighbors(text=text,
                              neighbors_num=neighbors_limit,
                              tags_num=tags_limit,
                              filters=filters,
                              table=info_table,
                              fields=', '.join(fields))
    neighbors['text'] = text
    return JSONResponse(jsonable_encoder(neighbors), status_code=200)


@app.post('/search/image/')
async def get_text_neighbors(filename: str, neighbors_limit: int = 20, tags_limit: int = 5,
                             filters: Union[Filters, None] = None,
                             fields: Union[List['str'], None] = None):
    if fields is None:
        fields = ['filename', 'tags', 'label']
    neighbors = get_neighbors(filename=filename,
                              neighbors_num=neighbors_limit,
                              tags_num=tags_limit,
                              filters=filters,
                              table=text_info_table,
                              fields=', '.join(fields))
    neighbors['filename'] = filename
    return JSONResponse(jsonable_encoder(neighbors), status_code=200)


@app.post('/search/filters/')
async def get_filtered_samples(filters: Filters, limit=50):
    return JSONResponse({'images': finder.get_filtered_data(filters=filters,
                                                            table=info_table,
                                                            n=limit,
                                                            fields=', '.join(['filename', 'tags', 'label']))})
