#!/usr/bin/env bash

scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

IMAGE_ID=wti-build
IMAGE_NAME=cosmosis-sonarqube
IMAGE_VERSION=1.0.0

IMAGE_TAG=$IMAGE_ID/$IMAGE_NAME:$IMAGE_VERSION

# Build image
docker build --tag $IMAGE_TAG $scriptDir

# Tag and push to ECR
docker tag $IMAGE_TAG 247011381634.dkr.ecr.us-west-2.amazonaws.com/$IMAGE_TAG
docker push 247011381634.dkr.ecr.us-west-2.amazonaws.com/$IMAGE_TAG
