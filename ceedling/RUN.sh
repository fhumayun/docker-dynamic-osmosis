#!/bin/bash

imageId=wti-internal
imageName=ceedling
imageVersion=0.30-a
imageTag=$imageId/$imageName:$imageVersion

docker run --rm -ti -v $(pwd):/project $imageTag
