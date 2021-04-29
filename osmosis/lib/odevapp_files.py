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
    odevapp_path = sp.getoutput("aws s3 ls s3://osmosis-cicd-artifactbucket-1s4qfttb1z9mh/build/ ").split("\n")
    odevapp_path = [x for x in odevapp_path 
                          if x.endswith(".gz") and f"osmosis-dev{version}" in x]
    odevapp_path = sorted(odevapp_path)[-1]

    # TODO: change the split patterns to regex capture groups
    odevapp = odevapp_path.split(" ")[-1]
    o_version = sp.getoutput("echo %s | cut -d '-' -f 3" %odevapp)

    if "tar" in o_version: 
        o_version = ".".join(o_version.split(".")[:3])
        
    if not os.path.isfile("odevapp%s.tar.gz" %version):
        
        # Remove previous files if exist
        if glob.glob("odevapp*.tar.gz"):
            os.system("rm odevapp*.tar.gz")

        os.system(f"aws s3 cp s3://osmosis-cicd-artifactbucket-1s4qfttb1z9mh/build/{odevapp} ./odevapp{version}.tar.gz")

    return o_version