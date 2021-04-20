General Docker container configuration repository.

# Containers

## crosstool-ng

Crosstool-NG builds the toolchain, and provides a baseline set of tools used to create specific cross compiler toolchains down the line (see cross-toolchain below).

## Osmosis

Build the docker images for running osmosis on Ubuntu and Centos and push them to ECR.

## cross-toolchain

A specific cross compiler toolchain used to cross compile Raspberry Pi AArch64 targeted binaries.


## Ceedling

The Ceedling unit test framework allows embedded C applications to be unit tested without target hardware.

## Pipelines

Contains various container descriptions used in the CICD pipelines for the different projects