# Specifying the base image on top of which we add new layers
FROM tiangolo/uvicorn-gunicorn-fastapi:python3.8

MAINTAINER "akshay.pachaar@tomtom.com"

# RUN is a command used to add new layers on top of base layer
RUN pip3 install --upgrade pip

# Installing tf Model server
# (The new image would have tf-serving preinstalled along with fastapi and uvicorn)
RUN echo "deb [arch=amd64] http://storage.googleapis.com/tensorflow-serving-apt stable tensorflow-model-server tensorflow-model-server-universal" | tee /etc/apt/sources.list.d/tensorflow-serving.list && \
curl https://storage.googleapis.com/tensorflow-serving-apt/tensorflow-serving.release.pub.gpg | apt-key add -
RUN apt-get update && apt-get install tensorflow-model-server

# Sepcifying the working directoy of running container
# (Note: container has it's own file system)
WORKDIR /MLOps_Workshop

# Copyting the contents from host directory to Working dir of container
COPY . /MLOps_Workshop

# Installing other dependencies/libraries
RUN pip3 --no-cache-dir install -r requirements.txt

# Creating environment variable as per requirement
ENV MODEL_NAME=img_classifier
ENV MODEL_DIR=/MLOps_Workshop/models

# Making start.sh an executable
RUN ["chmod", "+x", "/MLOps_Workshop/start.sh"]

# Command that runs inside container when it has started
# In our case it would fire up the image classifier
CMD /MLOps_Workshop/start.sh
