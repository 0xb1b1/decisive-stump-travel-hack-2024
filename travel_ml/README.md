# Our ML Stack

1. XLM-Roberta-Large as Text Encoder + ViT-L/14
2. Mistral7B as Text Encoder + LLAVA
3. Redis, ClickHouse

# How to launch ML

1. Run

```bash
pip install -r requiremets.txt
```

2. You should launch 3 different files (if you have a server with V100 you can do that on 1 machine). It can be done
   with

```bash 
screen
```

3. Launch 4 screens and do one command in one screen sequentially (with different ip [--host])
```bash
uvicorn search_processor:app --reload --host 100.64.0.16 --port 8001
uvicorn click_api.api:app --reload --host 100.64.0.16 --port 8000
python gpu_processor.py
python queue_processor.py
```

First one launches our "search engine"
Second one starts publishing api, which can give info about images, delete them and find similar to uploaded ones
Third one is responsible for LLAVA metadata mapper
The forth one publishes images and work with clickhouse
