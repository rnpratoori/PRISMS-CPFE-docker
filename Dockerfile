FROM ubuntu:bionic

LABEL maintainer="rnp@iastate.edu"

USER root
RUN apt-get update && apt-get install -y software-properties-common \
    && add-apt-repository $REPO \
    && apt-get update && apt-get install -y \
    git \
    libdeal.ii-dev=$VERSION \
    locales \
    ssh \
    sudo \
    ninja-build \
    numdiff \
    wget \
    && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

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
