# Makefile

BUILD_DIR := ci/Dockerfile
IMAGE_NAME := hikariai/hikariai-web
IMAGE_TAG := latest
BASE_URL := https://hikariai.net
ENV := prod

# Modify tagging mechanism
ifeq ($(ENV), dev)
	export IMAGE_TAG=test
	export BASE_URL=http://10.10.10.50
else
	export IMAGE_TAG=latest
endif

# List of commands
build:
	@docker build -f $(BUILD_DIR) \
		-t $(IMAGE_NAME):$(IMAGE_TAG) \
		--build-arg ENV=$(ENV) \
		--build-arg BASE_URL=$(BASE_URL) \
		.

build-prod:
	@docker build -f $(BUILD_DIR) \
		-t $(IMAGE_NAME):$(IMAGE_TAG) \
		--build-arg ENV=$(ENV) \
		--build-arg ENV=$(BASE_URL) \
		.
	@docker push $(IMAGE_NAME):latest

local-run:
	@docker run -d --name hugo-web -p 80:80 $(IMAGE_NAME):test

prod-run:
	@docker run -d --name hugo-web -p 80:80 $(IMAGE_NAME):latest
