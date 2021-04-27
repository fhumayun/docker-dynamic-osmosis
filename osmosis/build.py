#!/usr/bin/env python3

import os
import argparse
import lib

parser = argparse.ArgumentParser(description="""Build docker images for running osmosis 
                                "or odevapp on Ubuntu 20.01 or Centos8 and publish them 
                                "to AWS ECR or run test containers. It is required to have 
                                "the star_local.jks file located on docker/osmosis folder
                                "to provide it to the containers.""")

parser.add_argument("-o", "--odevapp", help="build the docker images for odevapp",
                    action="store_true")
parser.add_argument("-v", "--version", action="store", dest="v", help="odevapp version")

args = parser.parse_args()

if args.odevapp:
    lib.odevapp_files.getOdevappTar(args.v)
    os.system("docker build --tag odevapp -f dockerfiles/Dockerfile.ubuntu.odevapp .")
