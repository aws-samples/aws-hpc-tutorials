---
title: "a. Docker Image"
weight: 13
tags: ["tutorial", "cloud9", "ParallelCluster"]
---

In the following steps we build a Docker image and then convert it to a [rootless](https://rootlesscontaine.rs/) image using enroot. This image contains the Megatron-LM training code we'll be running in the next step.

By building this as a container image we've greatly simplified the complexity of what needs to be installed on the underlying system, however it doesn't completely eliminate the need to have some software installed on both the AMI and the container. Most notably the device drivers, including [CUDA](https://docs.nvidia.com/deploy/cuda-compatibility/), [EFA](https://aws.amazon.com/hpc/efa/) and [NCCL](https://developer.nvidia.com/nccl) all need to be installed on both the AMI **and** on the container image with the same version. We'll use the following versions:

| Library       | Version       | A100 Min Version (P4) | H100 Min Version (P5) |
|---------------|---------------|-----------------------|:---------------------:|
|  EFA          |  `1.26.1`     |                       |     `1.26.1`          |
|  NCCL         |  `2.18.5`     |     `2.15.1`          |     `2.18.5`          |
|  NCCL OFI     |  `v1.7.3-aws` |     `1.6.0`           |     `v1.7.3-aws`      |
|  CUDA Driver  |  `535.54.03`  |      `450.80.02`      |     `535.54.03`       |
|  CUDA Version |  `12.2`       |      `11.4`           |     `11.8`            |


1. On the **HeadNode** create a file `megatron-lm.Dockerfile` with the following content:

```dockerfile
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

FROM nvcr.io/nvidia/pytorch:23.05-py3

ARG EFA_INSTALLER_VERSION=1.26.1
ARG AWS_OFI_NCCL_VERSION=v1.7.2-aws
ARG NCCL_TESTS_VERSION=master
ARG NCCL_VERSION=v2.15.5-1
ARG OPEN_MPI_PATH=/opt/amazon/openmpi

######################
# Update and remove the IB libverbs
######################
RUN apt-get update -y
RUN apt-get remove -y --allow-change-held-packages \
                      libmlx5-1 ibverbs-utils libibverbs-dev libibverbs1 \
                      libnccl2 libnccl-dev

######################
# Add enviroment variable for processes to be able to call fork()
######################
ENV RDMAV_FORK_SAFE=1

RUN DEBIAN_FRONTEND=noninteractive apt install -y --allow-unauthenticated \
    git \
    gcc \
    vim \
    kmod \
    openssh-client \
    openssh-server \
    build-essential \
    curl \
    autoconf \
    libtool \
    gdb \
    automake \
    cmake \
    apt-utils && \
    DEBIAN_FRONTEND=noninteractive apt autoremove -y

RUN mkdir -p /var/run/sshd && \
    sed -i 's/[ #]\(.*StrictHostKeyChecking \).*/ \1no/g' /etc/ssh/ssh_config && \
    echo "    UserKnownHostsFile /dev/null" >> /etc/ssh/ssh_config && \
    sed -i 's/#\(StrictModes \).*/\1no/g' /etc/ssh/sshd_config && \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

RUN rm -rf /root/.ssh/ \
 && mkdir -p /root/.ssh/ \
 && ssh-keygen -q -t rsa -N '' -f /root/.ssh/id_rsa \
 && cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys \
 && printf "Host *\n  StrictHostKeyChecking no\n" >> /root/.ssh/config

ENV LD_LIBRARY_PATH=/usr/local/cuda/extras/CUPTI/lib64:/opt/amazon/openmpi/lib:/opt/nccl/build/lib:/opt/amazon/efa/lib:/opt/aws-ofi-nccl/install/lib:$LD_LIBRARY_PATH
ENV PATH=/opt/amazon/openmpi/bin/:/opt/amazon/efa/bin:/usr/bin:/usr/local/bin:$PATH

#################################################
## Install EFA installer
RUN cd $HOME \
    && curl -O https://efa-installer.amazonaws.com/aws-efa-installer-${EFA_INSTALLER_VERSION}.tar.gz \
    && tar -xf $HOME/aws-efa-installer-${EFA_INSTALLER_VERSION}.tar.gz \
    && cd aws-efa-installer \
    && ./efa_installer.sh -y --skip-kmod

###################################################
## Install NCCL
RUN git clone https://github.com/NVIDIA/nccl /opt/nccl \
    && cd /opt/nccl \
    && git checkout ${NCCL_VERSION} \
    && make -j$(nproc) src.build CUDA_HOME=/usr/local/cuda \
    NVCC_GENCODE="-gencode=arch=compute_86,code=sm_86 -gencode=arch=compute_80,code=sm_80 -gencode=arch=compute_75,code=sm_75 -gencode=arch=compute_70,code=sm_70 -gencode=arch=compute_60,code=sm_60"

###################################################
## Install AWS-OFI-NCCL plugin
RUN export OPAL_PREFIX="" \
    && git clone https://github.com/aws/aws-ofi-nccl.git /opt/aws-ofi-nccl \
    && cd /opt/aws-ofi-nccl \
    && env \
    && git checkout ${AWS_OFI_NCCL_VERSION} \
    && ./autogen.sh \
    && ./configure --prefix=/opt/aws-ofi-nccl/install \
       --with-libfabric=/opt/amazon/efa \
       --with-cuda=/usr/local/cuda \
       --with-mpi=/opt/amazon/openmpi/ \
       --enable-platform-aws \
    && make && make install

###################################################
RUN rm -rf /var/lib/apt/lists/*
ENV LD_PRELOAD=/opt/nccl/build/lib/libnccl.so

RUN echo "hwloc_base_binding_policy = none" >> /opt/amazon/openmpi/etc/openmpi-mca-params.conf \
 && echo "rmaps_base_mapping_policy = slot" >> /opt/amazon/openmpi/etc/openmpi-mca-params.conf

RUN pip3 install awscli 
RUN pip3 install pynvml 

RUN mv $OPEN_MPI_PATH/bin/mpirun $OPEN_MPI_PATH/bin/mpirun.real \
 && echo '#!/bin/bash' > $OPEN_MPI_PATH/bin/mpirun \
 && echo '/opt/amazon/openmpi/bin/mpirun.real "$@"' >> $OPEN_MPI_PATH/bin/mpirun \
 && chmod a+x $OPEN_MPI_PATH/bin/mpirun

######################
# Transformers dependencies used in the model
######################
RUN pip install transformers==4.21.0

#####################
# Install megatron-lm
#####################
RUN cd /workspace && git clone https://github.com/NVIDIA/Megatron-LM.git \
	&& cd Megatron-LM \
	&& python3 -m pip install nltk  \
	&& python -m pip install .
	
WORKDIR /workspace/Megatron-LM
```

2. Next we'll build that docker image:

```bash
docker build -t megatron-lm -f megatron-lm.Dockerfile .
```

3. Once it's built, convert the docker image to an enroot squash file:

```bash
enroot import -o /fsx/megatron-lm.sqsh  dockerd://megatron-lm:latest
```