#!/usr/bin/env bash

I_NAME=osmosis-java-runner

docker build --tag $I_NAME .

docker run \
    -it --rm \
    -p 8522:8522 \
    -v $(pwd)/executables:/app \
    $I_NAME