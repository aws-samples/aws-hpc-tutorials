# FROM pytorch/pytorch:1.7.1-cuda11.0-cudnn8-devel
# FROM pytorch/pytorch:1.10.0-cuda11.3-cudnn8-devel
# FROM pytorch/pytorch:1.11.0-cuda11.3-cudnn8-devel
FROM nvidia/cuda:11.4.2-cudnn8-devel-ubuntu20.04

ENV DEBIAN_FRONTEND noninteractive
# Key Cleanup
# https://forums.developer.nvidia.com/t/18-04-cuda-docker-image-is-broken/212892/10
RUN rm /etc/apt/sources.list.d/cuda.list
# RUN rm /etc/apt/sources.list.d/nvidia-ml.list
RUN apt-key del 7fa2af80
RUN apt-get update && apt-get install -y --no-install-recommends wget
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.0-1_all.deb
RUN dpkg -i cuda-keyring_1.0-1_all.deb
# RUN apt-key del 7fa2af80 \
#     && apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/3bf863cc.pub


RUN apt-get update && \
    apt-get install -y --no-install-recommends apt-utils && \
    apt-get install -y python3 && \
    apt-get install -y python3-pip && \
    pip3 install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu113


##############################################################################
# Temporary Installation Directory
##############################################################################
ENV STAGE_DIR=/tmp
RUN mkdir -p ${STAGE_DIR}

RUN apt-get update && \
    apt-get install -y vim git tmux wget curl autoconf libtool apt-utils nano

##############################################################################
# OPENMPI
##############################################################################
# Cuda Support has to be enabled, otherwise it will not work
# shell$ ompi_info --parsable --all | grep mpi_built_with_cuda_support:value
# mca:mpi:base:param:mpi_built_with_cuda_support:value:true
# https://www.open-mpi.org/faq/?category=buildcuda
ENV OPENMPI_BASEVERSION=4.0
ENV OPENMPI_VERSION=${OPENMPI_BASEVERSION}.1
RUN cd ${STAGE_DIR} && \
    wget -q -O - https://download.open-mpi.org/release/open-mpi/v${OPENMPI_BASEVERSION}/openmpi-${OPENMPI_VERSION}.tar.gz | tar xzf - && \
    cd openmpi-${OPENMPI_VERSION} && \
    ./configure --prefix=/usr/local/openmpi-${OPENMPI_VERSION} --with-cuda && \
    make -j"$(nproc)" install && \
    ln -s /usr/local/openmpi-${OPENMPI_VERSION} /usr/local/mpi && \
    # Sanity check:
    test -f /usr/local/mpi/bin/mpic++ && \
    cd ${STAGE_DIR} && \
    rm -r ${STAGE_DIR}/openmpi-${OPENMPI_VERSION}
ENV PATH=/usr/local/mpi/bin:${PATH} \
    LD_LIBRARY_PATH=/usr/local/lib:/usr/local/mpi/lib:/usr/local/mpi/lib64:${LD_LIBRARY_PATH}
# Create a wrapper for OpenMPI to allow running as root by default
RUN mv /usr/local/mpi/bin/mpirun /usr/local/mpi/bin/mpirun.real && \
    echo '#!/bin/bash' > /usr/local/mpi/bin/mpirun && \
    echo 'mpirun.real --allow-run-as-root --prefix /usr/local/mpi "$@"' >> /usr/local/mpi/bin/mpirun && \
    chmod a+x /usr/local/mpi/bin/mpirun

RUN apt-get update \
    && apt-get install -y openssh-server
RUN mkdir /var/run/sshd

ENV HOME /root
RUN echo $HOME

##############################################################################
# SSH Setup
##############################################################################
ENV SSHDIR $HOME/.ssh
RUN mkdir -p ${SSHDIR} \
&& touch ${SSHDIR}/sshd_config \
&& ssh-keygen -t rsa -f ${SSHDIR}/ssh_host_rsa_key -N '' \
&& cp ${SSHDIR}/ssh_host_rsa_key.pub ${SSHDIR}/authorized_keys \
&& cp ${SSHDIR}/ssh_host_rsa_key ${SSHDIR}/id_rsa \
&& echo "       IdentityFile ${SSHDIR}/id_rsa" >> ${SSHDIR}/config \
&& echo "       StrictHostKeyChecking no" >> ${SSHDIR}/config \
&& echo "       UserKnownHostsFile /dev/null" >> ${SSHDIR}/config \
&& echo "       Port 2022" >> ${SSHDIR}/config \
&& echo 'Port 2022' >> ${SSHDIR}/sshd_config \
&& echo "HostKey ${SSHDIR}/ssh_host_rsa_key" >> ${SSHDIR}/sshd_config \
&& echo "PidFile ${SSHDIR}/sshd.pid" >> ${SSHDIR}/sshd_config \
&& chmod -R 600 ${SSHDIR}/*
RUN eval `ssh-agent -s` && ssh-add ${SSHDIR}/id_rsa

ADD Container-Root/entry-point.sh /entry-point.sh
ADD Container-Root/prepare_sshd_startup.sh /prepare_sshd_startup.sh
ADD Container-Root/prep_mpi_run.sh /prep_mpi_run.sh
ADD Container-Root/extract_key.py /extract_key.py

ADD Container-Root/conf/supervisord.conf /conf/supervisord.conf

RUN pip3 install supervisor
ENV WORK_DIR=/workspace
WORKDIR /workspace

RUN apt-get install curl unzip -y && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install

# Basic mpirun tests (https://mpitutorial.com/tutorials/mpi-hello-world/)
RUN git clone https://github.com/mpitutorial/mpitutorial && \
    cd mpitutorial/tutorials/mpi-hello-world/code && \
    make  && \
    cd ./../../mpi-scatter-gather-and-allgather/code && \
    make

# Make the nccl-tests with MPI on
RUN git clone https://github.com/NVIDIA/nccl-tests.git && \
    cd nccl-tests && \
    MPI=1 MPI_HOME=/usr/local/mpi CUDA_HOME=/usr/local/cuda NCCL_HOME=/usr/lib/x86_64-linux-gnu make

# Download the pytorch distributed tests
RUN git clone https://github.com/pytorch/pytorch.git && \
    cd pytorch && \
    git clone https://github.com/pytorch/examples.git

# Get the fairseq version which does not need deepspeed to work
# We get a strange numpy compatibility issue
#RUN git clone https://github.com/pytorch/fairseq.git && \
#    cd fairseq && \
#    pip3 install --editable ./ && \
#    pip3 install --upgrade numpy

# Install Deep Speed

RUN apt-get install -y libaio-dev pdsh
RUN pip3 install --no-cache-dir deepspeed
ADD requirements.txt requirements.txt
RUN pip3 install -r requirements.txt
RUN pip3 install --upgrade protobuf==3.20.0
RUN pip3 install tensorboardX boto3 h5py mpi4py sacrebleu

# Deepspeed single node from transformers requires a fresh install
RUN git clone https://github.com/huggingface/transformers.git && \
    cd transformers && \
    pip3 install . && \
    pip3 install datasets==2.3.2 huggingface_hub==0.7.0

# Single and Multi node usecase with deepspeed using mistral
# Lock in the branch since it seems to be in active development
RUN git clone https://github.com/stanford-crfm/mistral.git && \
    cd mistral/ && \
    git checkout disable_wandb_better && \
    pip3 install quinine jsonlines wandb accelerate

RUN apt-get install -y iproute2

CMD /entry-point.sh
