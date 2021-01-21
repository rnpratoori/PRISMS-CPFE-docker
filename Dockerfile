FROM ubuntu:bionic

LABEL maintainer="rnp@iastate.edu"

USER root
RUN apt-get update && apt-get install -y software-properties-common \
    && apt-get update && apt-get install -y locales\
    sudo  \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get install -y build-essential lsb-release wget \
   automake autoconf gfortran \
   openmpi-bin openmpi-common libopenmpi-dev cmake subversion git \
   libblas-dev liblapack-dev libblas3 liblapack3 \
   libsuitesparse-dev libtool libboost-all-dev zlib1g-dev \
   splint tcl tcl-dev environment-modules qt4-dev-tools
