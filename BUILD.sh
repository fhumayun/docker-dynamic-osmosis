#!/bin/bash

scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

imageId=wti-internal
imageName=crosstool-ng
imageVersion=1.24.0
imageTag=$imageId/$imageName:$imageVersion

docker build --tag $imageTag $scriptDir
