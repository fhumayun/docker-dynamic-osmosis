#!/usr/bin/env bash

scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

IMAGE_ID=wti-dev
IMAGE_NAME=cloud
IMAGE_VERSION_UBUNTU=ubuntu20.10-x64
IMAGE_VERSION_CENTOS=centos8-x64

REGISTRY_URL="247011381634.dkr.ecr.us-west-2.amazonaws.com"

IMAGE_TAG_UBUNTU="$REGISTRY_URL/$IMAGE_ID/$IMAGE_NAME:$IMAGE_VERSION_UBUNTU"
IMAGE_TAG_CENTOS="$REGISTRY_URL/$IMAGE_ID/$IMAGE_NAME:$IMAGE_VERSION_CENTOS"

# Build images
docker build -f Dockerfile.ubuntu --tag $IMAGE_TAG_UBUNTU $scriptDir
docker build -f Dockerfile.centos --tag $IMAGE_TAG_CENTOS $scriptDir

# Tag and push to ECR
docker push $IMAGE_TAG_UBUNTU
docker push $IMAGE_TAG_CENTOS
