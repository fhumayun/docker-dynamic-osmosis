#!/bin/bash

scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

target=aarch64-rpi3-linux-gnu

imageId=wti-internal
imageName=cross-toolchain
imageVersion=$target
imageTag=$imageId/$imageName:$imageVersion

docker build --build-arg TARGET=$target --tag $imageTag $scriptDir
