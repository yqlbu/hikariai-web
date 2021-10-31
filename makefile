# Makefile

BUILD_DIR := ci/Dockerfile
DOCKERHUB_USERNAME := hikariai
GHCR_USERNAME := yqlbu
IMAGE_NAME := hikariai-web
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
		-t $(DOCKERHUB_USERNAME)/$(IMAGE_NAME):$(IMAGE_TAG) \
		--build-arg ENV=$(ENV) \
		--build-arg SERVER_IP=$(SERVER_IP) \
		--build-arg DOMAIN_NAME=$(DOMAIN_NAME) \
		.

build-staging:
	@docker build -f $(BUILD_DIR) \
		-t $(DOCKERHUB_USERNAME)/$(IMAGE_NAME):$(IMAGE_TAG) \
		--build-arg ENV=$(ENV) \
		--build-arg SERVER_IP=$(SERVER_IP) \
		--build-arg DOMAIN_NAME=staging.$(DOMAIN_NAME) \
		.
	@docker tag $(DOCKERHUB_USERNAME)/$(IMAGE_NAME):$(IMAGE_TAG) $(DOCKERHUB_USERNAME)/$(IMAGE_NAME):staging

build-prod:
	@docker build -f $(BUILD_DIR) \
		-t $(DOCKERHUB_USERNAME)/$(IMAGE_NAME):$(IMAGE_TAG) \
		--build-arg ENV=$(ENV) \
		--build-arg SERVER_IP=$(SERVER_IP) \
		--build-arg DOMAIN_NAME=www.$(DOMAIN_NAME) \
		.
	@docker tag $(DOCKERHUB_USERNAME)/$(IMAGE_NAME):$(IMAGE_TAG) $(DOCKERHUB_USERNAME)/$(IMAGE_NAME):prod

ghcr-login:
	@echo $(GHCR_TOKEN) | docker login ghcr.io -u $(GHCR_USERNAME) --password-stdin

push: ghcr-login
	@docker push $(DOCKERHUB_USERNAME)/$(IMAGE_NAME):staging
	@docker push $(DOCKERHUB_USERNAME)/$(IMAGE_NAME):latest
	@docker push ghcr.io/$(GHCR_USERNAME)/$(IMAGE_NAME):latest

push-prod:
	@docker push $(DOCKERHUB_USERNAME)/$(IMAGE_NAME):prod

local-run:
	@docker run -it --rm --name hugo-web -p 80:80 $(DOCKERHUB_USERNAME)/$(IMAGE_NAME):dev

staging-run:
	@docker run -d --name hugo-web -p 80:80 $(DOCKERHUB_USERNAME)/$(IMAGE_NAME):latest
