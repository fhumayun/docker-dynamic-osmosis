#!/usr/bin/env python3

import os
import argparse
import lib

parser = argparse.ArgumentParser(description="""Build docker images for running 
                                odevapp on Ubuntu 20.01 or Centos8 and publish them 
                                to AWS ECR or run test containers.""")

parser.add_argument("-v", "--version", action="store", dest="version_number", help="odevapp version")
parser.add_argument("-p", "--push", help="Push the images to ECR",
                    action="store_true")
parser.add_argument("-r", "--run", help="Run sample containers",
                    action="store_true")

# Parse incoming parameters
args = parser.parse_args()


o_version = lib.odevapp_files.getOdevappTar(args.version_number)

image_id = "wti-dev"
image_name = "osmosis"
image_version_ubuntu = "ubuntu20.10-x64"
image_version_centos = "centos8-x64"
registry_url="247011381634.dkr.ecr.us-west-2.amazonaws.com"

image_tag_ubuntu = registry_url + "/" + image_id + "/" + image_name + ":osmosis" + o_version + image_version_ubuntu 
image_tag_centos = registry_url + "/" + image_id + "/" + image_name + ":osmosis" + o_version + image_version_centos 

# Build images
os.system("docker build --tag %s -f %s/dockerfiles/Dockerfile.ubuntu.odevapp ." %(image_tag_ubuntu, os.getcwd()) )
os.system("docker build --tag %s -f %s/dockerfiles/Dockerfile.centos.odevapp ." %(image_tag_centos, os.getcwd()) )

if args.push:
    os.system("docker push %s" %image_tag_ubuntu)
    os.system("docker push %s" %image_tag_centos)

if args.run:
    os.system("docker run --name centosodevapp -h odevappcentos -d" \
    " -e NODE_ID='11111111-aaaa-3333-4444-555555555555' %s" %image_tag_centos)
    os.system("docker run --name ubuntuodevapp -h odevappubuntu -d" \
    " -e NODE_ID='aaaaaaaa-1111-cccc-dddd-eeeeeeeeeeee' %s" %image_tag_ubuntu)