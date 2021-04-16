#!/usr/bin/env bash

set -e 

if [ ! -e "osmosis.tar.gz" ]; then
    mkdir osmosis
    cd osmosis

    if [ ! -f "../../osmosis/star_local.jks" ]; then 
        echo star_local.jks not found, it should be located at ../../osmosis/ ; 
        exit
    fi

    # get star_local certificate
    CERT_PATH=$(ls -l ../../osmosis/star_local.jks | cut -d">" -f 2-)
    cp $CERT_PATH ./star_local.jks

    # get the name of the last cloud artifact
    CLOUD_FULLPATH=$(aws s3 ls s3://osmosis-cicd-artifactbucket-1s4qfttb1z9mh/build/ | grep cloud-dev | grep '\.gz$' | sort | tail -1)
    CLOUD=$(echo $CLOUD_FULLPATH | cut -d ' ' -f 4)

    # bundle cloud
    aws s3 cp s3://osmosis-cicd-artifactbucket-1s4qfttb1z9mh/build/$CLOUD ./cloud.tar.gz
    tar xf cloud.tar.gz
    rm cloud.tar.gz

    # get the name of the last manager artifact
    MANAGER_FULLPATH=$(aws s3 ls s3://osmosis-cicd-artifactbucket-1s4qfttb1z9mh/manager/ | grep manager-dev | sort | tail -1)
    MANAGER=$(echo $MANAGER_FULLPATH | cut -d ' ' -f 4)

    # bundle manager
    mkdir manager
    cd manager
    aws s3 cp s3://osmosis-cicd-artifactbucket-1s4qfttb1z9mh/manager/$MANAGER ./manager.tar.gz
    tar xf manager.tar.gz
    rm manager.tar.gz

    # compress everything
    cd ..
    tar -czf ../osmosis.tar.gz *
    cd ..
    rm -rf osmosis
fi

U_NAME=osmosis-ubuntu-runner
C_NAME=osmosis-centos-runner
docker build -f Dockerfile.ubuntu --tag $U_NAME .
docker build -f Dockerfile.centos --tag $C_NAME .

docker run \
    --name centoscloudcontainer \
    -d \
    -h testcentos \
    -e CONTAINER_ID="11111111-2222-3333-4444-555555555555" \
    $C_NAME

docker run \
    --name ubuntucloudcontainer \
    -h testubuntu \
    -e CONTAINER_ID="aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee" \
    -e "TCP=cloud.dev.windtalker.com test test2 test3" \
    -p 8522:8522 \
    $U_NAME