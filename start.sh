#!/bin/bash
nohup tensorflow_model_server --rest_api_port=8501 --model_name=${MODEL_NAME} --model_base_path=${MODEL_DIR} &
uvicorn main:app --port 8080 --host 0.0.0.0 --reload --log-level error
