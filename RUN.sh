#!/bin/bash

imageId=wti-internal
imageName=crosstool-ng
imageVersion=1.24.0
imageTag=$imageId/$imageName:$imageVersion

docker run --rm -ti $imageTag
