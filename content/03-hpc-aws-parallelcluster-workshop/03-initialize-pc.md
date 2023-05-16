+++
title = "c. Set up AWS ParallelCluster foundation"
date = 2023-04-10T10:46:30-04:00
weight = 30
tags = ["tutorial", "ssh"]
+++

To ease configuration of AWS ParallelCluster, you could use the interactive command **[pcluster configure](https://docs.aws.amazon.com/parallelcluster/latest/ug/install-v3-configuring.html)** within the command line interface. This configuration tool walks you through a step-by-step process of defining your cluster configuration; to provide information such as the AWS Region, VPC, Subnet, and [Amazon EC2](https://aws.amazon.com/ec2/) Instance Type. For this workshop, however, you will create a custom configuration file to include the HPC specific options for this lab.

In this section, you will set up the foundation (for example network, scheduler, ...) required to build the ParallelCluster config file in the next section.

{{% notice info %}}Don't skip these steps, it is important to follow each step sequentially, copy-paste and run these commands.
{{% /notice %}}

Retrieve network information and set environment variables. In these steps you will also be writing these environment variables into a file in your working directory which can be sourced and set again in case you logout of the session.

Your HPC cluster configuration will need network information such as VPC ID, Subnet ID and create a SSH Key. A lot of this could be set manu
To ease the setup, you will use a script for settings of those parameters.
If you have time and are curious, you can examine the different steps of the script.

#### 1. Retrieve the script.
```bash
wget https://isc23.hpcworkshops.com/scripts/aws-parallelcluster/ISC23_lab1_create_parallelcluster_config.sh
```

#### 2. Execute the script to retrieve network information.
```bash
source ./ISC23_lab1_create_parallelcluster_config.sh
```

#### 3. Store the SSH key in AWS Secrets Manager as a failsafe in the event that the private SSH key is lost.
```bash
b64key=$(base64 ~/.ssh/${SSH_KEY_NAME})
aws secretsmanager create-secret --name ${SSH_KEY_NAME} \
    --description "Private key file" \
    --secret-string "$b64key" \
    --region ${AWS_REGION}
```

Next, you build a configuration to generate a cluster to run  HPC applications.

{{% notice info %}}
**Optional Step**: Please run this command **ONLY** in the event that you lose your SSH private key and need to retrieve it from the secrets manager

```bash
aws secretsmanager get-secret-value --secret-id ${SSH_KEY_NAME} \
    --query 'SecretString' \
    --region ${AWS_REGION} \
    --output text | base64 --decode > ~/.ssh/${SSH_KEY_NAME}

chmod 400 ~/.ssh/${SSH_KEY_NAME}
```
{{% /notice %}}
