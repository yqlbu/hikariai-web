# Makefile

BUILD_DIR := ci/Dockerfile
IMAGE_NAME := hikariai/hikariai-web
IMAGE_TAG := latest
DOMAIN_NAME := hikariai.net
ENV := prod
SERVER_IP := 10.10.10.50

# Modify tagging mechanism
ifeq ($(ENV), dev)
	export IMAGE_TAG=dev
else
	export IMAGE_TAG=staging
endif

# List of commands
build:
	@docker build -f $(BUILD_DIR) \
		-t $(IMAGE_NAME):$(IMAGE_TAG) \
		--build-arg ENV=$(ENV) \
		--build-arg SERVER_IP=$(SERVER_IP) \
		--build-arg DOMAIN_NAME=$(DOMAIN_NAME) \
		.

push:
	@docker tag $(IMAGE_NAME):staging
	@docker push $(IMAGE_NAME):latest

local-run:
	@docker run -d --name hugo-web -p 80:80 $(IMAGE_NAME):dev

prod-run:
	@docker run -d --name hugo-web -p 80:80 $(IMAGE_NAME):latest
