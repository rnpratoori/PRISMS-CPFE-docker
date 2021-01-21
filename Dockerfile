FROM ubuntu:bionic

LABEL maintainer="rnp@iastate.edu"

USER root
RUN apt-get update && apt-get install -y software-properties-common \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
RUN locale-gen en_US.UTF-8
