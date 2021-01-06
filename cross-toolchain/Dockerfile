FROM wti-internal/crosstool-ng:1.24.0

ARG TARGET


WORKDIR /home/dev
RUN mkdir /home/dev/RPi && mkdir /home/dev/src
WORKDIR /home/dev/RPi
COPY ${TARGET}.config .config


RUN ct-ng build || { cat build.log && false; } && rm -rf .build

ENV TOOLCHAIN_PATH=/home/dev/x-tools/${TARGET}
ENV PATH=${TOOLCHAIN_PATH}/bin:$PATH
ENV CXX_PREFIX=aarch64-rpi3-linux-gnu-
WORKDIR /home/dev