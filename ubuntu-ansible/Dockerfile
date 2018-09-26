FROM ubuntu:18.04

RUN apt-get update && \
  apt-get --yes install software-properties-common curl && \
  apt-add-repository ppa:ansible/ansible && \
  apt-get update && \
  apt-get --yes install ansible=2.6.4-1ppa~bionic

CMD ["/bin/bash"]
