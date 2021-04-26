#!/usr/bin/env python3

import os
import subprocess as sp

def getOdevappTar():
    # Get the tar file from AWS S3
    odevapp_path = sp.getoutput("aws s3 ls s3://osmosis-cicd-artifactbucket-1s4qfttb1z9mh/build/ "\
                                "| grep cloud-dev | grep '\.gz$' | sort | tail -1")
    odevapp = sp.getoutput("echo %s | cut -d ' ' -f 4" %odevapp_path)
    os.system("aws s3 cp s3://osmosis-cicd-artifactbucket-1s4qfttb1z9mh/build/%s ./odevapp.tar.gz" %odevapp)

if __name__ == "__main__":
    getOdevappTar()