#!/usr/bin/env python3

import os
import subprocess as sp
import glob

def getOdevappTar(version):
    # Get the tar file from AWS S3
    if version is not None:
        version = "-" + version
    else:
        version = ""
        
    if not os.path.isfile("odevapp%s.tar.gz" %version):
        if glob.glob("odevapp*.tar.gz"):
            os.system("rm odevapp*.tar.gz")

        odevapp_path = sp.getoutput("aws s3 ls s3://osmosis-cicd-artifactbucket-1s4qfttb1z9mh/build/ " \
                                    "| grep osmosis-dev%s | grep '\.gz$' | sort | tail -1" %version)
        odevapp = sp.getoutput("echo %s | cut -d ' ' -f 4" %odevapp_path)
        os.system("aws s3 cp s3://osmosis-cicd-artifactbucket-1s4qfttb1z9mh/build/%s ./odevapp%s.tar.gz" % (odevapp, version))