#!/usr/bin/env python3

import os
import subprocess as sp

def getOdevappTar():
    # Get the tar file from AWS S3
    if not os.path.isfile('odevapp.tar.gz'):
        odevapp_path = sp.getoutput("aws s3 ls s3://osmosis-cicd-artifactbucket-1s4qfttb1z9mh/build/ "\
                                    "| grep osmosis-dev | grep '\.gz$' | sort | tail -1")
        odevapp = sp.getoutput("echo %s | cut -d ' ' -f 4" %odevapp_path)
        os.system("aws s3 cp s3://osmosis-cicd-artifactbucket-1s4qfttb1z9mh/build/%s ./odevapp.tar.gz" %odevapp)