import json
import boto3
import redis
from fastapi import FastAPI
from fastapi.encoders import jsonable_encoder
from rsmq import RedisSMQ
from starlette.responses import JSONResponse

from typing import List, Union

from loguru import logger

import os

import clickhouse_connect

from click_api.utils.click_client import NeighborFinder

from dotenv import load_dotenv  # for python-dotenv method

from click_api.utils.models import Filters

load_dotenv()

search_table = '''
            ((SELECT filename, embedding FROM images)
            UNION ALL
                (SELECT filename, embedding FROM tags) 
            UNION  ALL 
                (SELECT filename, embedding FROM labels))'''

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

client = clickhouse_connect.get_client(host=os.environ.get('DB_HOST'),
                                       port=int(os.environ.get('DB_PORT')),
                                       user=os.environ.get('DB_USER'),
                                       database=os.environ.get('DB'),
                                       password=os.environ.get('DB_PASSWORD'))

finder = NeighborFinder(client)

app = FastAPI()

redis_client = redis.Redis.from_url(os.environ.get("REDIS_URL"))
rsmq = RedisSMQ(client=redis_client)
logger.debug('Redis loaded')


@app.post('/images/neighbors/{filename}')
async def get_neighbors(filename: str, neighbors_limit: int = 30, filters: Union[Filters, None] = None):
    return JSONResponse({'images': finder.get_uploaded_neighbors(filename, k=neighbors_limit, table=info_table, filters=filters)})


@app.post('/images/info/{filename}')
async def get_image_info(filename: str, fields: List['str'] = None):
    if fields is None:
        fields = ['filename', 'tags', 'label']
    info = finder.get_fields(filename, fields=', '.join(fields), table=info_table)
    return JSONResponse(jsonable_encoder(info), status_code=200)


@app.delete('/images/del/{filename}')
async def get_image_info(filename: str):
    info = finder.delete_image(filename)
    return JSONResponse(jsonable_encoder({'message': f'Deleted {filename}'}), status_code=200)


@app.get('/main/{im_num}')
async def get_main(im_num: int):
    info = {'images': finder.get_sampled_images(im_num, fields=', '.join(['filename', 'tags', 'label']),
                                                table=info_table)}
    rsmq.client.set(name=f'images:collections:main', value=json.dumps(info), ex=60 * 30)
    return JSONResponse(jsonable_encoder({'message': f'Successfully updated main with {len(info["images"])} images'}),
                        status_code=200)
