#!/usr/bin/env bash

#? This docker image will be compiled to ARM64-v8 using Docker's cross compilation functionality. 
#? The resulting container should work fine on Raspberry Pi devices, but it's main goal is that of
#? running on a AWS CodeBuild ARM machine.

scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

IMAGE_ID=wti-build
IMAGE_NAME=cosmosis-aarch64

IMAGE_VERSION=1.0.1

REGISTRY_URL="247011381634.dkr.ecr.us-west-2.amazonaws.com"

IMAGE_TAG=$IMAGE_ID/$IMAGE_NAME:$IMAGE_VERSION

# Create a new multiarch builder by executing 
docker buildx create --name comsosis-aarch64-builder

# Bootstrap the new builder 
docker buildx use comsosis-aarch64-builder 
docker buildx inspect --bootstrap

# Build image, tag, and push to ECR
docker buildx build \
    --memory=8000mb \
    --platform=linux/arm64/v8 \
    --tag "$REGISTRY_URL/$IMAGE_TAG" $scriptDir \
    --push