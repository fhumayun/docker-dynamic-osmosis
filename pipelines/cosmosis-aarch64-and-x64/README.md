This Dockerfile is the same for both ARM64 and x64 build images. The difference is how the image itself is
build (the architecture for which it is built). This is possible because the base image we're using,
`centos:8`, is available for both architectures. 