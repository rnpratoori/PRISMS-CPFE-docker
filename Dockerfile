FROM ubuntu:bionic

LABEL maintainer="rnp@iastate.edu"


RUN apt-get install -y build-essential lsb-release wget \
   automake autoconf gfortran \
   openmpi-bin openmpi-common libopenmpi-dev cmake subversion git \
   libblas-dev liblapack-dev libblas3 liblapack3 \
   libsuitesparse-dev libtool libboost-all-dev zlib1g-dev \
   splint tcl tcl-dev environment-modules qt4-dev-tools

# add and enable the default user
ARG USER=rnp
RUN adduser --disabled-password --gecos '' $USER
RUN adduser $USER sudo; echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

#make sure everything is in place
RUN chown -R $USER:$USER /home/$USER
USER $USER
ENV HOME /home/$USER
ENV USER $USER
ENV OMPI_MCA_btl "^vader"
WORKDIR $HOME

#install dealii from candi without trilinos
RUN git clone https://github.com/rnpratoori/candi.git
RUN cd candi
RUN ./candi.sh

ENV DEAL_II_DIR /home/rnp/dealii-candi/

#install PRSISMS-CPFE
RUN git clone https://github.com/prisms-center/plasticity.git
RUN cd plasticity
RUN cp /src/materialModels/crystalPlasticity/MaterialModels/RateIndependentAdvancedTwinModel2/calculatePlasticity.cc /src/materialModels/crystalPlasticity/
RUN cmake .
RUN make
RUN cd applications/crystalPlasticity
RUN cmake .
RUN make release
