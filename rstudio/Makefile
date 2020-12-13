PARENT_DOCKER=shmohammadi86/genomics:bioc
REGISTRY=shmohammadi86
IMAGE_NAME=genomics
VERSION=rstudio

all: build

build:
	docker build \
	  --tag $(IMAGE_NAME):${VERSION} \
	  --tag $(REGISTRY)/$(IMAGE_NAME):${VERSION} \
	  --build-arg PARENT_DOCKER=ubuntu:20.04 \
	  -t $(IMAGE_NAME) .
test:
	docker run --rm -it $(IMAGE) bash
