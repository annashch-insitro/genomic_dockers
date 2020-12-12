IMAGE=mro-verse
VERSION=4.0.2
REGISTRY=shmohammadi86
PARENT_DOCKER=shmohammadi86/mro

all: build

build:
	docker build -t $(IMAGE) -t $(IMAGE):${VERSION} -t $(REGISTRY)/$(IMAGE) -t $(REGISTRY)/$(IMAGE):${VERSION} --build-arg PARENT_DOCKER=${PARENT_DOCKER} .

test:
	docker run --rm -it $(IMAGE) bash
