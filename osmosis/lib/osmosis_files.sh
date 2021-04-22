#!/usr/bin/env bash

set -e

# Creates the osmosis.tar.gz file. Use latest version of `manager`
# Parameters:
# 1. The version `cloud` to bundle inside the image.
# 2. The version `manager` to bundle inside the image.
buildTar()
{   
    # Delete osmosis folder if exist from previous executions
    if [ -d "osmosis" ]; then
        rm -rf osmosis
    fi

    # Check the cloud version number
    if [ -z $1 ]; then
            echo "No cloud version number provided, using latest"
        else
            RC_VERSION=-$1
    fi

    # get the name of the cloud artifact
    CLOUD_FULLPATH=$(aws s3 ls s3://osmosis-cicd-artifactbucket-1s4qfttb1z9mh/build/ | grep cloud-dev$RC_VERSION | grep '\.gz$' | sort | tail -1)
    CLOUD=$(echo $CLOUD_FULLPATH | cut -d ' ' -f 4)
    C_VERSION=$(echo $CLOUD | cut -d '-' -f 3)
            

    if [ -z $CLOUD ]; then 
        echo "Version provided for cloud doesn't exist"
        exit
    fi

    # Check if the cloud version provided doesn't have a date
    if [ ! -z $(echo $C_VERSION | grep tar) ]; then
        C_VERSION=$(echo $C_VERSION | cut -d '.' -f -3)
    fi
    
    # Check the manager version number
    if [ -z $2 ]; then
            echo "No manager version number provided, using latest"
        else
            RM_VERSION=-$2
    fi

    # get the name of the last manager artifact
    MANAGER_FULLPATH=$(aws s3 ls s3://osmosis-cicd-artifactbucket-1s4qfttb1z9mh/manager/ | grep manager-dev$RM_VERSION | sort | tail -1)
    MANAGER=$(echo $MANAGER_FULLPATH | cut -d ' ' -f 4)
    M_VERSION=$(echo $MANAGER | cut -d '-' -f 3)

    if [ -z $MANAGER ]; then 
        echo "Version provided for manager doesn't exist"
        exit
    fi

    # Check if the manager version provided doesn't have a date
    if [ ! -z $(echo $M_VERSION | grep tar) ]; then
        M_VERSION=$(echo $M_VERSION | cut -d '.' -f -3)
    fi  

    if [ ! -e osmosis-cloud$C_VERSION-manager$M_VERSION.tar.gz ]; then

        # Remove previous versions of osmosis tar file.
        if [ -e osmosis-cloud*.tar.gz ]; then
            rm osmosis-cloud*.tar.gz
        fi
        
        if [ ! -f star_local*.jks ]; then 
            echo "star_local.jks not found, it should be located at main folder of osmosis"
            exit
        fi

        mkdir osmosis
        cd osmosis

        # get star_local certificate
        cp ../star_local*.jks ./star_local.jks

        # bundle cloud
        aws s3 cp s3://osmosis-cicd-artifactbucket-1s4qfttb1z9mh/build/$CLOUD ./cloud.tar.gz
        tar xf cloud.tar.gz
        rm cloud.tar.gz

        # bundle manager
        mkdir manager
        cd manager
        aws s3 cp s3://osmosis-cicd-artifactbucket-1s4qfttb1z9mh/manager/$MANAGER ./manager.tar.gz
        tar xf manager.tar.gz
        rm manager.tar.gz

        # compress everything
        cd ..
        tar -czf ../osmosis-cloud$C_VERSION-manager$M_VERSION.tar.gz *
        cd ..
        rm -rf osmosis
    fi
}