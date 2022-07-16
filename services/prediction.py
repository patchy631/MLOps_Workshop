import requests
import json
import numpy as np

class_names = [
    "T-shirt/top",
    "Trouser",
    "Pullover",
    "Dress",
    "Coat",
    "Sandal",
    "Shirt",
    "Sneaker",
    "Bag",
    "Ankle boot",
]


def predict(data, version):
    headers = {"content-type": "application/json"}
    json_response = requests.post(
        f"http://localhost:8501/v1/models/img_classifier/versions/{version}:predict",
        data=data,
        headers=headers,
    )
    predictions = json.loads(json_response.text)["predictions"]

    return f"Its a {class_names[np.argmax(predictions[0])]}"
