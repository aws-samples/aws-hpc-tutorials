+++
title = "b. Set up AWS ParallelCluster foundation"
date = 2019-09-18T10:46:30-04:00
weight = 40
tags = ["tutorial", "initialize", "ParallelCluster"]
+++

Typically, to configure AWS ParallelCluster, you use the interactive command [**pcluster configure**](https://docs.aws.amazon.com/parallelcluster/latest/ug/getting-started-configuring-parallelcluster.html) to provide the information, such as the AWS Region, Scheduler, and EC2 Instance Type.
For this workshop, you will create a custom configuration file to include the HPC specific options for this lab.

In this section, you will set up the foundation ( for example network, Scheduler etc ) required to build the ParallelCluster config file in the next section.

{{% notice info %}}Don't skip these steps, it is important to follow each step sequentially, copy paste and run these commands
{{% /notice %}}

Retrieve network information and set environment variables. In these steps you will also be writing these environment variables into a file in your working directory which can be sourced and set again in case you logout of the session.

1. Set AWS Region

```bash

AWS_REGION=$(curl --silent http://169.254.169.254/latest/meta-data/placement/region)
echo "export AWS_REGION=${AWS_REGION}" >> env_vars

```

2. Set VPC ID by retrieving the ID of the default VPC

```bash

VPC_ID=`aws ec2 describe-vpcs --output text \
    --query 'Vpcs[*].VpcId' \
    --filters Name=isDefault,Values=true \
    --region ${AWS_REGION}`
echo "export VPC_ID=${VPC_ID}" >> env_vars
```

3. Set Amazon EC2 instance types that be will be used through this lab for head and compute nodes in the following sections (sections c and h )

```bash

INSTANCES=c5n.18xlarge,c5.large

```

4. Find the Availability Zone where the EC2 instances are available

```bash

AZ_W_INSTANCES=`aws ec2 describe-instance-type-offerings --location-type "availability-zone" \
    --filters Name=instance-type,Values=${INSTANCES} \
    --query InstanceTypeOfferings[].Location \
    --region ${AWS_REGION} | jq -r ".[]" | sort`

```

5. Set subnet ID based on the Availability Zone in which the EC2 instances are available

```bash

INSTANCE_TYPE_COUNT=`echo ${INSTANCES} | awk -F "," '{print NF-1}'`

if [ ${INSTANCE_TYPE_COUNT} -gt 0 ]; then
    AZ_W_INSTANCES=`echo ${AZ_W_INSTANCES} | tr ' ' '\n' | uniq -d`
fi
AZ_W_INSTANCES=`echo ${AZ_W_INSTANCES} | tr ' ' ',' | sed 's%,$%%g'`


if [[ -z ${AZ_W_INSTANCES} ]]; then
    echo "[ERROR] failed to retrieve availability zone"
    return 1
fi

AZ_COUNT=`echo ${AZ_W_INSTANCES} | tr -s ',' ' ' | wc -w`
SUBNET_ID=`aws ec2 describe-subnets --query "Subnets[*].SubnetId" \
    --filters Name=vpc-id,Values=${VPC_ID} \
    Name=availability-zone,Values=${AZ_W_INSTANCES} \
    --region ${AWS_REGION} \
    | jq -r .[$(python3 -S -c "import random; print(random.randrange(${AZ_COUNT}))")]`

if [[ ! -z ${SUBNET_ID} ]]; then
    echo "[INFO] SUBNET_ID = ${SUBNET_ID}"
    echo "export SUBNET_ID=${SUBNET_ID}" >> env_vars
else
    echo "[ERROR] failed to retrieve SUBNET ID"
    return 1
fi

```

The following steps set up SSH Access Key required to access the cluster in later sections

6. Create SSH Access Key "hpc-workshop-key" if it does not exsist already

```bash

SSH_KEY_NAME="hpc-workshop-key.pem"

[ ! -d ~/.ssh ] && mkdir -p ~/.ssh && chmod 700 ~/.ssh

SSH_KEY_EXIST=`aws ec2 describe-key-pairs --query KeyPairs[*] --filters Name=key-name,Values=${SSH_KEY_NAME} --region ${AWS_REGION} | jq "select(length > 0)"`

if [[ -z ${SSH_KEY_EXIST} ]]; then
    aws ec2 create-key-pair --key-name ${SSH_KEY_NAME} \
        --query KeyMaterial \
        --region ${AWS_REGION} \
        --output text > ~/.ssh/${SSH_KEY_NAME}

    chmod 400 ~/.ssh/${SSH_KEY_NAME}
else
    echo "[WARNING] SSH_KEY_NAME ${SSH_KEY_NAME} already exist"
fi

echo "[INFO] SSH_KEY_NAME = ${SSH_KEY_NAME}"
echo "export SSH_KEY_NAME=${SSH_KEY_NAME}" >> env_vars
```

7. Store the SSH key in AWS Secrets Manager as a failsafe in the event that the private SSH key is lost

```bash

b64key=$(base64 ~/.ssh/${SSH_KEY_NAME})
aws secretsmanager create-secret --name ${SSH_KEY_NAME} \
    --description "Private key file" \
    --secret-string "$b64key" \
    --region ${AWS_REGION}

```

8. (OPTIONAL STEP )Please run this command ONLY in the event that you lose your SSH private key and need to retrieve it from the secrets manager

```bash

aws secretsmanager get-secret-value --secret-id ${SSH_KEY_NAME} \
    --query 'SecretString' \
    --region ${AWS_REGION} \
    --output text | base64 --decode > ~/.ssh/${SSH_KEY_NAME}
```

9. Set Operating System

```bash

BASE_OS="alinux2"
echo "export BASE_OS=${BASE_OS}" >> env_vars
```

10. Set the job scheduler

```bash

SCHEDULER="slurm"
echo "export SCHEDULER=${SCHEDULER}" >> env_vars
```

Next, you build a configuration to generate a cluster to run  HPC applications.