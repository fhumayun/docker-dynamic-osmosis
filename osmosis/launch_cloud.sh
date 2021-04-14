#!/usr/bin/env bash

set -e 

if [ ! -e "osmosis.tar.gz" ]; then
    mkdir osmosis
    cd osmosis

    # get star_local certificate
    CERT_PATH=$(ls -l ~/osmosis/star_local.jks | cut -d">" -f 2-)
    cp $CERT_PATH ./star_local.jks

    # bundle cloud
    aws s3 cp s3://osmosis-cicd-artifactbucket-1s4qfttb1z9mh/build/cloud-dev-0.12.5-20210319T184924Z.tar.gz ./cloud.tar.gz
    tar xf cloud.tar.gz
    rm cloud.tar.gz

    # bundle manager
    mkdir manager
    cd manager
    aws s3 cp s3://osmosis-cicd-artifactbucket-1s4qfttb1z9mh/manager/manager-dev-0.12.10-20210408T202152UTC.tar.gz ./manager.tar.gz
    tar xf manager.tar.gz
    rm manager.tar.gz

    # compress everything
    cd ..
    tar -czf ../osmosis.tar.gz *
    cd ..
    rm -rf osmosis
fi

I_NAME=osmosis-java-runner
docker build --tag $I_NAME .

docker run \
    -it --rm \
    -p 8522:8522 \
    $I_NAME