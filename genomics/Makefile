IMAGE=genomics
VERSION=1.0.0
REGISTRY=shmohammadi86
PARENT_DOCKER=mro-bioc

all: build

build:
	docker build -t $(IMAGE) -t $(IMAGE):${VERSION} -t $(REGISTRY)/$(IMAGE) -t $(REGISTRY)/$(IMAGE):${VERSION} --build-arg PARENT_DOCKER=${PARENT_DOCKER} .

test:
	docker run --rm -it $(IMAGE) bash
