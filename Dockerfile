FROM ubuntu:18.04


# update and install needed packages
RUN apt-get update && \
    apt-get install -y \
        autoconf \
        make


# add user dev, add dev to sudo group
RUN useradd -m dev && \
    echo "dev:dev" | chpasswd && \
    usermod -aG sudo dev


USER dev
WORKDIR /home/dev


