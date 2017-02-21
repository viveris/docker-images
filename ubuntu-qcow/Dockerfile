FROM ubuntu:16.04
RUN apt-get update &&  \
    apt-get install -y libguestfs-tools qemu-utils && \
    apt-get clean && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
