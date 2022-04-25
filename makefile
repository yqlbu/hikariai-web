# Makefile

BUILD_DIR := ci/Dockerfile
DOCKERHUB_USERNAME := hikariai
REGISTRY := docker.io
IMAGE_NAME := hikariai-web
IMAGE_TAG := dev
DOMAIN_NAME := hikariai.net
ENV := prod
SERVER_IP := 10.178.0.50

# Modify tagging mechanism
ifeq ($(ENV), dev)
	export IMAGE_TAG=dev
else ifeq ($(ENV), prod)
	export IMAGE_TAG=prod
	export DOMAIN_NAME=www.hikariai.net
else
	export IMAGE_TAG=staging
	export DOMAIN_NAME=staging.hikariai.net
endif

# List of commands
build:
	@sudo nerdctl build -f $(BUILD_DIR) \
		-t docker.io/$(DOCKERHUB_USERNAME)/$(IMAGE_NAME):$(IMAGE_TAG) \
		--build-arg ENV=$(ENV) \
		--build-arg SERVER_IP=$(SERVER_IP) \
		--build-arg DOMAIN_NAME=$(DOMAIN_NAME) \
		.

build-prod:
	@sudo nerdctl build -f $(BUILD_DIR) \
		-t docker.io/$(DOCKERHUB_USERNAME)/$(IMAGE_NAME):$(IMAGE_TAG) \
		--build-arg ENV=$(ENV) \
		--build-arg SERVER_IP=$(SERVER_IP) \
		--build-arg DOMAIN_NAME=$(DOMAIN_NAME) \
		.

push:
	@sudo nerdctl push $(IMAGE_NAME):$(IMAGE_TAG) \
    docker://$(REGISTRY)/$(DOCKERHUB_USERNAME)/$(IMAGE_NAME):$(IMAGE_TAG)

local-run:
	@sudo nerdctl run -it --rm --name hikariai-web -p 80:80 $(DOCKERHUB_USERNAME)/$(IMAGE_NAME):prod
