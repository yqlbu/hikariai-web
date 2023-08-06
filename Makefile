BUILD_DIR := Dockerfile
DOCKERHUB_USERNAME := hikariai
REGISTRY := docker.io
IMAGE_NAME := hikariai-web
IMAGE_TAG := dev
DOMAIN_NAME := www.hikariai.net
ENV := prod

build:
    docker build -f ${BUILD_DIR} \
    -t $(REGISTRY)/$(DOCKERHUB_USERNAME)/$(IMAGE_NAME):$(IMAGE_TAG) \
    .

run:
    docker run -it --rm --name hikariai-web -p 3000:80 $(DOCKERHUB_USERNAME)/$(IMAGE_NAME):$(IMAGE_TAG)

push:
    docker push $(REGISTRY)/$(DOCKERHUB_USERNAME)/$(IMAGE_NAME):$(IMAGE_TAG)

.PHONY: build run
