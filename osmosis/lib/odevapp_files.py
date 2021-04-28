#!/usr/bin/env python3

import os
import subprocess as sp
import glob

# Get the tar file from AWS S3
def getOdevappTar(version):
    
    if version is not None:
        version = "-" + version
    else:
        version = ""
    
    # Check the name of the artifact
    odevapp_path = sp.getoutput("aws s3 ls s3://osmosis-cicd-artifactbucket-1s4qfttb1z9mh/build/ " \
                                "| grep osmosis-dev%s | grep '\.gz$' | sort | tail -1" %version)
    odevapp = sp.getoutput("echo %s | cut -d ' ' -f 4" %odevapp_path)
    o_version = sp.getoutput("echo %s | cut -d '-' -f 3" %odevapp)

    if len(sp.getoutput("echo %s | grep tar" %o_version)) > 0: 
        o_version = sp.getoutput("echo %s | cut -d '.' -f -3" %o_version)
        
    if not os.path.isfile("odevapp%s.tar.gz" %version):
        
        # Remove previous files if exist
        if glob.glob("odevapp*.tar.gz"):
            os.system("rm odevapp*.tar.gz")

        os.system("aws s3 cp s3://osmosis-cicd-artifactbucket-1s4qfttb1z9mh/build/%s ./odevapp%s.tar.gz" % (odevapp, version))

    return o_version