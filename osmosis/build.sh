#!/usr/bin/env bash

LIBDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/lib" >/dev/null 2>&1 && pwd )"
source "$LIBDIR/osmosis_files.sh"

set -e

#---------------------------------------------------------------------------------------
# FUNCTIONS
#---------------------------------------------------------------------------------------

# Provides text that describes how to use this script
usage() {
    cat <<EOF
    
Usage: $(basename "${BASH_SOURCE[0]}") [options]
	
Build docker images for running osmosis on Ubuntu 20.01 or Centos8
and publish them to AWS ECR or run test containers.
It is required to have the star_local.jks file located on docker/osmosis folder
to provide it to the containers.

Available options:
    -h, --help                                    Print this help and exit
    -p, --push                                    Push the images to AWS ECR
    -r, --run                                     Create test containers for Ubuntu and Centos
    -t, --tar                                     Create tar file from scratch.
    -c, --cloud   <artifact version>              Cloud-dev version for the tar file, by default use latest.
    -m, --manager <artifact version>              Manager-dev version for the tar file, by default use latest.
                                                  Sample version format: 0.12.5 
    
EOF
    exit
}

# Parse input parameters to initialize script
parseParams() {
    while :; do
        case "${1-}" in
        -h | --help)
            usage
            ;;
        -p | --push)
            PUSH=true
            ;;
        -r | --run)
            RUN=true
            ;;
        -t | --tar)
            if [ -e osmosis-cloud*.tar.gz ]; then
                rm osmosis-cloud*.tar.gz
            fi
            ;;
        -c | --cloud)
            CLOUD_VERSION="${2-}"
            shift
            ;;
        -m | --manager)
            MANAGER_VERSION="${2-}"
            shift
            ;;
        -?*)
            echo "${txtred}Unknown option: $1${txtrst}"
            usage
            exit 1
            ;;
        *) break ;;
        esac
        shift
    done
    return 0
}

#---------------------------------------------------------------------------------------
# MAIN
#---------------------------------------------------------------------------------------

# Parse incoming parameters
unset PUSH RUN CLOUD_VERSION MANAGER_VERSION
parseParams "$@"

buildTar "$CLOUD_VERSION" "$MANAGER_VERSION"

scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )/dockerfiles/." >/dev/null 2>&1 && pwd )"

IMAGE_ID=wti-dev
IMAGE_NAME=cloud
IMAGE_VERSION_UBUNTU=ubuntu20.10-x64
IMAGE_VERSION_CENTOS=centos8-x64
    
REGISTRY_URL="247011381634.dkr.ecr.us-west-2.amazonaws.com"
    
IMAGE_TAG_UBUNTU="$REGISTRY_URL/$IMAGE_ID/$IMAGE_NAME:cloud$C_VERSION-manager$M_VERSION-$IMAGE_VERSION_UBUNTU"
IMAGE_TAG_CENTOS="$REGISTRY_URL/$IMAGE_ID/$IMAGE_NAME:cloud$C_VERSION-manager$M_VERSION-$IMAGE_VERSION_CENTOS"

# Build images
docker build --tag $IMAGE_TAG_UBUNTU -f $scriptDir/Dockerfile.ubuntu.cloud .
docker build --tag $IMAGE_TAG_CENTOS -f $scriptDir/Dockerfile.centos.cloud .


if [ "$PUSH" == "true" ]; then
    # Tag and push to ECR
    docker push $IMAGE_TAG_UBUNTU
    docker push $IMAGE_TAG_CENTOS

fi

if [ "$RUN" == "true" ]; then

# Containers parameters:
# --name: Name for the container
# -d: Runs container on deamon mode
# -p: Publish the ports of the container
# h: Set hostname for containers, this will be the name of the node
# -e NODE_ID="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx": Id for the node
# -e "TCP=XXX": Address for tcp connections.

# Creates Centos container and runs it on daemon mode
    docker run \
        --name centoscloudcontainer \
        -h testcentos \
        -d \
        -e NODE_ID="11111111-2222-3333-4444-555555555555" \
        -e "TCP=cloud.dev.windtalker.com" \
        $IMAGE_TAG_CENTOS

# Creates ubuntu container and publish the 8522 port
# This container is not on daemon mode
    docker run \
        --name ubuntucloudcontainer \
        -h testubuntu \
        -e NODE_ID="aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee" \
        -e "TCP=cloud.dev.windtalker.com" \
        -p 8522:8522 \
        -p 9091:9091 \
        $IMAGE_TAG_UBUNTU
fi