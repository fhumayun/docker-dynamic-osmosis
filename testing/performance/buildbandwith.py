#!/usr/bin/env python3

import os
import subprocess as sp
import tarfile

def getBandwith():
    # Create the tar file for performance
    if not os.path.isfile('performance.tar.gz'):
        os.system("git clone ssh://git-codecommit.us-west-2.amazonaws.com/v1/repos/performance")

        with tarfile.open('performance.tar.gz', "w:gz") as tar:
            tar.add('performance')

        os.system("rm -rf performance")
    
    #os.system("cp perfomance.tar.gz ../dockerfiles")
    os.system("docker build --tag performance -f ../dockerfiles/Dockerfile.root .")


if __name__ == "__main__":
    getBandwith()
