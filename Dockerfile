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


# clone the latest version of crosstool-ng and make it
RUN git clone -b master --single-branch --depth 1 https://github.com/crosstool-ng/crosstool-ng.git
WORKDIR /home/dev/crosstool-ng
RUN ./bootstrap && \
    ./configure --prefix=/home/dev/.local && \
    make -j$(($(nproc) * 2)) && \
    make install &&  \
    rm -rf /home/dev/crosstool-ng
ENV PATH=/home/dev/.local/bin:$PATH


# start in /home/dev
WORKDIR /home/dev
RUN rm -rf /home/dev/crosstool-ng