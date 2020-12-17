#!/bin/bash

imageId=wti-internal
imageName=aarch64-cross-compile
imageVersion=0.1-a
imageTag=$imageId/$imageName:$imageVersion

docker run --rm -ti $imageTag
