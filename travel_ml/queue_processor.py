import io
import json
import os

import clickhouse_connect
import redis
from loguru import logger

from PIL import Image as Im

import ruclip

from rsmq.rsmq import RedisSMQ

import boto3

from click_api.utils.click_client import NeighborFinder
from click_api.utils.models import Image
import torch

from models.models import RuClipEmbedder

from dotenv import load_dotenv


def get_bytes_image(filename, s3_client, bucket='images-comp'):
    obj = s3_client.get_object(Bucket=bucket, Key=filename)
    return io.BytesIO(obj['Body'].read())


def pop_from_queue(qname: str, red_conn: RedisSMQ):
    item = red_conn.popMessage(quiet=True, qname=qname).exceptions(False).execute()
    return item


def push_to_queue(item, qname: str, red_conn: RedisSMQ):
    red_conn.sendMessage(message=item, qname=qname).exceptions(False).execute()


def update_tags(filename, image_embedding, tags, embedder, finder):
    logger.debug('adding tags')
    tags_embeddings = embedder.get_text_embeddings(tags)
    finder.update_fields([tags, tags_embeddings.tolist()], 'tags_info', column_oriented=True)
    similarity = image_embedding @ tags_embeddings.mean(0)
    finder.update_fields([filename, tags, similarity, tags_embeddings.mean(0).tolist()], 'tags')
    logger.debug('tags added')


def update_description(filename, image_embedding, label, embedder, finder):
    logger.debug('adding label')
    desc_embedding = embedder.get_text_embeddings([label]).squeeze()
    similarity = image_embedding @ desc_embedding
    finder.update_fields([filename, label, similarity, desc_embedding.tolist()], 'labels')
    logger.debug('label added')


def update_meta(image, finder):  # TODO
    finder.update_fields([image.filename,
                          image.weather,
                          image.season,
                          image.time_of_day,
                          image.atmosphere,
                          image.number_of_people,
                          image.main_color,
                          image.orientation], 'metas')


def main(s3, embedder, finder, rsmq):
    while True:
        queue_request = pop_from_queue('analyze-backend-ml', rsmq)
        if queue_request:
            try:
                logger.debug('Got request')
                queue_request = json.loads(queue_request['message'])
                task_type = queue_request.pop('task_type')
                image = Image(**queue_request)
            except Exception as e:
                redis_client.set(f'images:update:error',
                                 json.dumps({'error': 'field error'}),
                                 ex=60 * 5)
                logger.exception(e)
                continue

            logger.debug(f"Task type {task_type}")

            if task_type == 'add_image':
                try:
                    logger.debug('getting image embedding')
                    bytes_image = get_bytes_image(image.filename, s3)
                    pil_image = Im.open(bytes_image)
                    image_embedding = embedder.get_image_embeddings([pil_image]).squeeze()

                    # TODO: Return warning if similar image is in database

                    logger.debug('adding image to db')
                    finder.add_image([image.filename, image_embedding])
                    lower_tags = []
                    for tag in image.tags:
                        lower_tags.append(tag.lower())
                    update_tags(image.filename, image_embedding, lower_tags, embedder, finder)
                    update_description(image.filename, image_embedding, image.label, embedder, finder)
                    update_meta(image, finder)
                    redis_client.set(f'images:publish:ready:{image.filename}',
                                     json.dumps(image.dict(), ensure_ascii=False),
                                     ex=60 * 5)
                    logger.debug(f'Image {image.filename} uploaded')

                except Exception as e:
                    logger.error(image.dict())
                    redis_client.set(f'images:publish:error:{image.filename}',
                                     json.dumps({'error': 'error'}),
                                     ex=60 * 5)
                    logger.exception(e)

            elif task_type in ['update_label', 'update_tags', 'update_meta']:
                image_embedding = torch.tensor(finder.get_fields(image.filename, 'embedding', 'images')['embedding'])
                if task_type == 'update_tags':
                    try:
                        lower_tags = []
                        for tag in image.tags:
                            lower_tags.append(tag.lower())
                        update_tags(image.file, image_embedding, lower_tags, embedder, finder)
                        redis_client.set(f'images:info:update:tags:ready:{image.filename}',
                                         json.dumps(image.dict(), ensure_ascii=False),
                                         ex=60 * 5)
                    except Exception as e:
                        redis_client.set(f'images:update:tags:error:{image.filename}',
                                         json.dumps({'error': 'error'}),
                                         ex=60 * 5)
                        logger.exception(e)
                elif task_type == 'update_meta':
                    try:
                        update_meta(image, finder)
                        redis_client.set(f'images:info:update:meta:ready:{image.filename}',
                                         json.dumps(image.dict(), ensure_ascii=False), ex=60 * 5)
                    except Exception as e:
                        redis_client.set(f'images:update:meta:error:{image.filename}',
                                         json.dumps({'error': 'error'}),
                                         ex=60 * 5)
                        logger.exception(e)
                else:
                    try:
                        update_description(image.file, image_embedding, image.label, embedder, finder)
                        redis_client.set(f'images:info:update:label:ready:{image.filename}',
                                         json.dumps(image.dict(), ensure_ascii=False), ex=60 * 5)
                    except Exception as e:
                        redis_client.set(f'images:update:label:error:{image.filename}',
                                         json.dumps({'error': 'error'}),
                                         ex=60 * 5)
                        logger.exception(e)


if __name__ == "__main__":
    load_dotenv()

    session = boto3.session.Session()
    s3 = session.client(service_name='s3',
                        endpoint_url=os.environ.get('S3_HOST'),
                        aws_access_key_id=os.environ.get('S3_ID'),
                        aws_secret_access_key=os.environ.get('S3_KEY'))

    logger.debug('S3 loaded')

    clip_model, clip_preprocessor = ruclip.load('ruclip-vit-base-patch16-384', device='cpu')
    clip_model.load_state_dict(torch.load('moscow_finetune.pth'))
    embedder = RuClipEmbedder(clip_model, clip_preprocessor, 'cpu')
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
    main(s3, embedder, finder, rsmq)
