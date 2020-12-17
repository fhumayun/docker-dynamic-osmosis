#!/bin/bash

scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

imageId=wti-internal
imageName=aarch64-cross-compile
imageVersion=0.1-a
imageTag=$imageId/$imageName:$imageVersion

docker build --tag $imageTag $scriptDir
