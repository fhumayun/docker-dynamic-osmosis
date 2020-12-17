FROM ubuntu:18.04


# update and install needed packages
#   source: https://github.com/crosstool-ng/crosstool-ng/blob/master/testing/docker/ubuntu18.04/Dockerfile
RUN apt-get update && \
    apt-get install -y \
        autoconf \
        automake \
        bison \
        bzip2 \
        file \
        flex \
        g++ \
        gawk \
        gcc \
        git \
        help2man \
        libncurses5-dev \
        libstdc++6 \
        libtool \
        libtool-bin \
        make \
        patch \
        python3-dev \
        rsync \
        texinfo \
        unzip \
        wget \
        xz-utils


# add user dev, add dev to sudo group
RUN useradd -m dev && \
    echo "dev:dev" | chpasswd && \
    usermod -aG sudo dev


USER dev
WORKDIR /home/dev


