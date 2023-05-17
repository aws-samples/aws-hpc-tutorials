#!/bin/bash

# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this
# software and associated documentation files (the "Software"), to deal in the Software
# without restriction, including without limitation the rights to use, copy, modify,
# merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
# INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
# PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

sudo yum -y -q install jq




# Define AWS Region
if [ -z ${AWS_REGION} ]; then
    echo "[WARNING] AWS_REGION environment variable is not set, automatically set depending where you run this script"
    export AWS_REGION=$(curl --silent http://169.254.169.254/latest/meta-data/placement/region)
fi
echo "export AWS_REGION=${AWS_REGION}" > env_vars
echo "[INFO] AWS_REGION = ${AWS_REGION}"




# Define Head Node Instance type.
if [ -z ${HEAD_NODE_INSTANCE} ]; then
    echo "[WARNING] HEAD_NODE_INSTANCE environment variable is not set, automatically set to c5.xlarge"
    export HEAD_NODE_INSTANCE=c5.xlarge
fi
echo "export HEAD_NODE_INSTANCE=${HEAD_NODE_INSTANCE}" >> env_vars
echo "[INFO] HEAD_NODE_INSTANCE = ${HEAD_NODE_INSTANCE}"




# Define Compute Instances seperated by ','.
if [ -z ${COMPUTE_INSTANCES} ]; then
    echo "[WARNING] COMPUTE_INSTANCES environment variable is not set, automatically set to c5n.18xlarge"
    export COMPUTE_INSTANCES=c5n.18xlarge
fi
echo "export COMPUTE_INSTANCES=${COMPUTE_INSTANCES}" >> env_vars
echo "[INFO] COMPUTE_INSTANCES = ${COMPUTE_INSTANCES}"




# Create SSH Key called hpc-lab-key and place it in the .ssh folder in our user directory
export SSH_KEY_NAME="hpc-lab-key"

[ ! -d ~/.ssh ] && mkdir -p ~/.ssh && chmod 700 ~/.ssh

SSH_KEY_EXIST=`aws ec2 describe-key-pairs --query KeyPairs[*] --filters Name=key-name,Values=${SSH_KEY_NAME} --region ${AWS_REGION} | jq "select(length > 0)"`

if [[ -z ${SSH_KEY_EXIST} ]]; then
    aws ec2 create-key-pair --key-name ${SSH_KEY_NAME} \
        --query KeyMaterial \
        --region ${AWS_REGION} \
        --output text > ~/.ssh/${SSH_KEY_NAME}

    chmod 400 ~/.ssh/${SSH_KEY_NAME}
else
    echo "[WARNING] SSH_KEY_NAME ${SSH_KEY_NAME} already exists"
fi

echo "[INFO] SSH_KEY_NAME = ${SSH_KEY_NAME}"
echo "export SSH_KEY_NAME=${SSH_KEY_NAME}" >> env_vars




# Retrieve VPC ID and Subnet ID
# By default, the script is looking for the default VPC and retrieves its ID.
# You can alternatively set the VPC ID as an environment variable `VPC_ID` of your choice instead.
if [[ -z ${VPC_ID} ]]; then
    VPC_ID=`aws ec2 describe-vpcs --output text \
        --query 'Vpcs[*].VpcId' \
        --filters Name=isDefault,Values=true \
        --region ${AWS_REGION}`
fi

if [[ ! -z $VPC_ID ]]; then
    echo "export VPC_ID=${VPC_ID}" >> env_vars
    echo "[INFO] VPC_ID = ${VPC_ID}"
else
    echo "[ERROR] failed to retrieve VPC ID"
    return 1
fi




AZ_IDS=euw1-az1,euw1-az2,euw1-az3
AZ_COUNT=`echo $AZ_IDS | tr -s ',' ' ' | wc -w`


# Set a subnet id by finding which subnet of the VPC is corresponding to the Availability Zone
# where EC2 instance are available.
export SUBNET_ID=`aws ec2 describe-subnets --query "Subnets[*].SubnetId" \
    --filters Name=vpc-id,Values=${VPC_ID} \
    Name=availability-zone-id,Values=${AZ_IDS} \
    --region ${AWS_REGION} \
    | jq -r .[$(python3 -S -c "import random; print(random.randrange(${AZ_COUNT}))")]`

if [[ ! -z $SUBNET_ID ]]; then
    echo "export SUBNET_ID=${SUBNET_ID}" >> env_vars
    echo "[INFO] SUBNET_ID = ${SUBNET_ID}"
else
    echo "[ERROR] failed to retrieve SUBNET ID"
    return 1
fi




# Specify a custom Amazon Machine Image (AMI) that has WRF already
# installed. This should return ami-0f077c9ce43173631
export CUSTOM_AMI=`aws ec2 describe-images --owners 280472923663 \
    --query 'Images[*].{ImageId:ImageId,CreationDate:CreationDate}' \
    --filters "Name=name,Values=*-amzn2-parallelcluster-3.5.1-wrf-4.2.2-*" \
    --region ${AWS_REGION} \
    | jq -r 'sort_by(.CreationDate)[-1] | .ImageId'`

echo "export CUSTOM_AMI=${CUSTOM_AMI}" >> env_vars
