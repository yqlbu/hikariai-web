# Makefile

BUILD_DIR := ci/Dockerfile
IMAGE_NAME := hikariai/hikariai-web
IMAGE_TAG := latest
BASE_URL := https://hikariai.net
ENV := prod

# Modify tagging mechanism
ifeq ($(ENV), dev)
	export IMAGE_TAG=test
else
	export IMAGE_TAG=latest
endif

# List of commands
build:
	@docker build -f $(BUILD_DIR) \
		-t $(IMAGE_NAME):$(IMAGE_TAG) \
		--build-arg ENV=$(ENV) \
		.

local-run:
	@docker run -d --name hugo-web -p 80:80 $(IMAGE_NAME):test

prod-run:
	@docker run -d --name hugo-web -p 80:80 $(IMAGE_NAME):latest
