---
title : "a. Upload training data to S3"
date: 2020-09-04T15:58:58Z
weight : 5
tags : ["configuration", "S3", "Conda", "data", "nccl", "efa"]
---

In this step, you create an environment configuration script to train a Natural Language Understanding model and upload the training data to an S3 bucket.

#### Create an Amazon S3 Bucket and Upload Training Data and Environment Setup Script

First, create an Amazon S3 bucket and upload the training data folder. This training folder will be accessed by the cluster worker nodes through FSx.

1. Open a terminal in your AWS Cloud9 instance.
2. Run the following commands to create a new Amazon S3 bucket. These commands also retrieve and store the [Wikitext 103 dataset](https://blog.einstein.ai/the-wikitext-long-term-dependency-language-modeling-dataset/)

```bash
# generate a unique postfix
export BUCKET_POSTFIX=$(uuidgen --random | cut -d'-' -f1)
echo "Your bucket name will be mlbucket-${BUCKET_POSTFIX}"
aws s3 mb s3://mlbucket-${BUCKET_POSTFIX}

# downloading data:
export URL="https://s3.amazonaws.com/research.metamind.io/wikitext/wikitext-103-v1.zip"
export FILE="wikitext-103-v1.zip"
wget $URL -O $FILE
unzip $FILE

# upload to your bucket
aws s3 cp wikitext-103 s3://mlbucket-${BUCKET_POSTFIX}/wikitext-103 --recursive

# delete local copies
rm -rf wikitext-103*
```

The next step is to create a post-installation script to be executed by ParallelCluster when provisioning the instances. This script first configures [**NVIDIA NCCL**](https://developer.nvidia.com/nccl) to work with the already available AWS EFA software. **NCCL** is the communication library used by _PyTorch_ for GPU-to-GPU communication. For more information, refer to the [Getting started with EFA and NCCL documentation](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/efa-start-nccl.html).

The script also installs [Miniconda3](https://docs.conda.io/en/latest/miniconda.html) and configures an environment with PyTorch and Fairseq in a shared filesystem. In the coming cluster configuration steps, you set up a [GP2 Amazon EBS](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AmazonEBS.html) volume that will be attached to the head node and shared through NFS to be mounted by the compute nodes on */shared*.

```bash
cat > post-install.sh << EOF
#!/bin/bash

# start configuration of NCCL and EFA only if CUDA and EFA present
CUDA_DIRECTORY=/usr/local/cuda
EFA_DIRECTORY=/opt/amazon/efa
OPENMPI_DIRECTORY=/opt/amazon/openmpi
if [ -d "\$CUDA_DIRECTORY" ] && [ -d "\$EFA_DIRECTORY" ]; then

    # installing NCCL
    NCCL_DIRECTORY=/home/ec2-user/nccl
    if [ ! -d "\$NCCL_DIRECTORY" ]; then
        echo "Installing NVIDIA nccl"
        cd /home/ec2-user
        git clone https://github.com/NVIDIA/nccl.git

        cd /home/ec2-user/nccl
        make -j src.build
    fi

    # installing aws-ofi-nccl
    AWS_OFI_DIRECTORY=/home/ec2-user/aws-ofi-nccl

    if [ ! -d "\$AWS_OFI_DIRECTORY" ]; then
        echo "Installing aws-ofi-nccl"
        cd /home/ec2-user
        git clone https://github.com/aws/aws-ofi-nccl.git -b aws
    fi
    cd \$AWS_OFI_DIRECTORY
    ./autogen.sh
    ./configure --with-mpi=\$OPENMPI_DIRECTORY --with-libfabric=\$EFA_DIRECTORY --with-nccl=\$NCCL_DIRECTORY/build --with-cuda=\$CUDA_DIRECTORY
    export PATH=\$OPENMPI_DIRECTORY/bin:\$PATH
    make
    sudo make install
fi

# configuring the conda environment
cd /shared
CONDA_DIRECTORY=/shared/.conda/bin

if [ ! -d "\$CONDA_DIRECTORY" ]; then
  # control will enter here if $DIRECTORY doesn't exist.
  echo "Conda installation not found. Installing..."
  wget -O miniconda.sh \
      "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh" \
      && bash miniconda.sh -b -p /shared/.conda \
      && /shared/.conda/bin/conda init bash \
      && eval "\$(/shared/.conda/bin/conda shell.bash hook)" \
      && rm -rf miniconda.sh

  conda install python=3.6 -y
fi

FAIRSEQ_DIRECTORY=/shared/fairseq

if [ ! -d "\$FAIRSEQ_DIRECTORY" ]; then
    # control will enter here if $DIRECTORY doesn't exist.
    echo "Fairseq repository not found. Installing..."
    git clone https://github.com/pytorch/fairseq.git \$FAIRSEQ_DIRECTORY

    pip install -e \$FAIRSEQ_DIRECTORY -U

    pip install boto3 torch tqdm -y
fi

chown -R ec2-user:ec2-user /lustre
chown -R ec2-user:ec2-user /shared

sudo -u ec2-user /shared/.conda/bin/conda init bash

EOF

# upload to your bucket
aws s3 cp post-install.sh s3://mlbucket-${BUCKET_POSTFIX}/post-install.sh

# delete local copies
rm -rf post-install.sh
```

Before continuing, check the content of your bucket using the AWS CLI with the command `aws s3 ls s3://mlbucket-${BUCKET_POSTFIX}` or the [AWS console](https://s3.console.aws.amazon.com/s3/).

Next, define the configuration of the ML cluster by creating the AWS ParallelCluster configuration file.
