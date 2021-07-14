#!/usr/bin/env bash
set -e

scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

IMAGE_ID=wti-build
IMAGE_NAME=cosmosis-x64_32
IMAGE_VERSION=1.0.1

REGISTRY_URL="247011381634.dkr.ecr.us-west-2.amazonaws.com"

IMAGE_TAG="$REGISTRY_URL/$IMAGE_ID/$IMAGE_NAME:$IMAGE_VERSION"

# Build image
docker build --tag $IMAGE_TAG $scriptDir

# Tag and push to ECR
docker push $IMAGE_TAG