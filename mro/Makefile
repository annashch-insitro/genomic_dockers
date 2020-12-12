IMAGE=mran
VERSION=4.0.2
REGISTRY=shmohammadi86
PARENT_DOCKER=ubuntu:20.04 

all: build

build:
	docker build -t $(IMAGE) -t $(IMAGE):${VERSION} -t $(REGISTRY)/$(IMAGE) -t $(REGISTRY)/$(IMAGE):${VERSION} --build-arg PARENT_DOCKER=${PARENT_DOCKER} .

test:
	docker run --rm -it $(IMAGE) bash
