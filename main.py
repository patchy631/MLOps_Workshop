import uvicorn
import numpy as np
import json
from fastapi import FastAPI, File, UploadFile
from PIL import Image
from io import BytesIO
import logging
from services import prediction

logging.basicConfig(level=logging.INFO)

app = FastAPI()


# class ImageClassifierData(BaseModel):
#     featureIds: List[str] = []


@app.get("/")
def index():
    return {"message": "Hello, This is a Fashion MNIST classification API"}


@app.post("/predict/fashion_item")
def classify_image(data):
    return prediction.get_dtfr_for_list_featureIds(data)


@app.post("/images/")
async def create_upload_file(file: UploadFile = File(...), version: int = 1):
    f = await file.read()
    img = Image.open(BytesIO(f))
    data = np.reshape(np.array(img), (1, 28, 28, 1)) / 255.0
    data = json.dumps({"instances": data.tolist()})
    result = prediction.predict(data, version)
    return {"result": result}


if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=80)
