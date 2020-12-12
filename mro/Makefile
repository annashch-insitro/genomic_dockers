IMAGE=mran
VERSION=4.0.2
REGISTRY=shmohammadi86

all: build

build:
	docker build -t $(IMAGE) -t $(IMAGE):${VERSION} -t $(REGISTRY)/$(IMAGE) -t $(REGISTRY)/$(IMAGE):${VERSION} --build-arg PARENT_DOCKER=ubuntu:20.04 .

test:
	docker run --rm -it $(IMAGE) bash
