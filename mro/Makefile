PARENT_DOCKER=ubuntu:20.04 
REGISTRY=shmohammadi86
IMAGE_NAME=genomics
VERSION=mro

all: build

build:
	docker build \
	  --tag $(IMAGE_NAME):${VERSION} \
	  --tag $(REGISTRY)/$(IMAGE_NAME):${VERSION} \
	  --build-arg PARENT_DOCKER=${PARENT_DOCKER} \
	  -t $(IMAGE_NAME) .
test:
	docker run --rm -it $(IMAGE) bash
