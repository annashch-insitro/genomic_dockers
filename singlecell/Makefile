PARENT_DOCKER=shmohammadi86/genomics:rstudio
REGISTRY=shmohammadi86
IMAGE_NAME=genomics
VERSION=singlecell

all: build

build:
	docker build \
	  --tag $(IMAGE_NAME):${VERSION} \
	  --tag $(REGISTRY)/$(IMAGE_NAME):${VERSION} \
	  --build-arg PARENT_DOCKER=${PARENT_DOCKER} \
	  -t $(IMAGE_NAME) .
test:
	docker run -it -p 8787:8787 --rm  $(IMAGE) bash
