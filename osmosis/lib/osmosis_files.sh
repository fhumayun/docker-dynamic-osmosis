#!/usr/bin/env bash

set -e

buildTar()
{   
    # Check the version number, if provided remove previous tar files
    if [ -z $1 ]
        then
            echo "No version number provided, using latest"
        else
            VERSION=-$1
            if [ -e "osmosis.tar.gz" ]; then
                rm osmosis.tar.gz
            fi
    fi
    
    # Delete osmosis folder if exist from previous executions
    if [ -d "osmosis" ]; then
        rm -rf osmosis
    fi
    
    if [ ! -e "osmosis.tar.gz" ]; then
        
        if [ ! -f star_local*.jks ]; then 
            echo "star_local.jks not found, it should be located at main folder of osmosis"
            exit
        fi

        # get the name of the last cloud artifact
        CLOUD_FULLPATH=$(aws s3 ls s3://osmosis-cicd-artifactbucket-1s4qfttb1z9mh/build/ | grep cloud-dev$VERSION | grep '\.gz$' | sort | tail -1)
        CLOUD=$(echo $CLOUD_FULLPATH | cut -d ' ' -f 4)
    
        if [ -z $CLOUD ]; then 
            echo "$VERSION version doesn't exist on cloud"
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
}