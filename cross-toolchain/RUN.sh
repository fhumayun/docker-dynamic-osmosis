#!/bin/bash

target=aarch64-rpi3-linux-gnu

imageId=wti-internal
imageName=cross-toolchain
imageVersion=$target
imageTag=$imageId/$imageName:$imageVersion

docker run --rm -ti -v $(pwd):/project $imageTag
