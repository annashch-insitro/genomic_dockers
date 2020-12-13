PARENT_DOCKER=shmohammadi86/genomics:bioc
REGISTRY=shmohammadi86
IMAGE_NAME=genomics
VERSION=rstudio

all: build

build:
	docker build \
	  --tag $(IMAGE_NAME):${VERSION} \
	  --tag $(REGISTRY)/$(IMAGE_NAME):${VERSION} \
	  --build-arg VCS_REF=`git rev-parse --short HEAD` \
	  --build-arg VCS_URL=`git config --get remote.origin.url` \
	  --build-arg BUILD_DATE=`date -u +”%Y-%m-%dT%H:%M:%SZ”` \
	  --build-arg BUILD_DATE=`date -u +”%Y-%m-%dT%H:%M:%SZ”` \
	  --build-arg PARENT_DOCKER=ubuntu:20.04 \
	  -t $(IMAGE_NAME) .
test:
	docker run --rm -it $(IMAGE) bash
