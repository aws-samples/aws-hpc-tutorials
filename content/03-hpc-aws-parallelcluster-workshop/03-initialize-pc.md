+++
title = "c. Set up AWS ParallelCluster foundation"
date = 2022-04-10T10:46:30-04:00
weight = 30
tags = ["tutorial", "ParallelCluster", "initialize"]
+++

Typically, to configure AWS ParallelCluster, you use the interactive command **[pcluster configure](https://docs.aws.amazon.com/parallelcluster/latest/ug/install-v3-configuring.html)** to provide the information, such as the AWS Region, VPC, Subnet, and [Amazon EC2](https://aws.amazon.com/ec2/) Instance Type.
For this workshop, you will create a custom configuration file to include the HPC specific options for this lab.

In this section, you will set up the foundation (for example network, scheduler, ...) required to build the ParallelCluster config file in the next section.

{{% notice info %}}Don't skip these steps, it is important to follow each step sequentially, copy paste and run these commands
{{% /notice %}}

Retrieve network information and set environment variables. In these steps you will also be writing these environment variables into a file in your working directory which can be sourced and set again in case you logout of the session.

Your HPC cluster configuration will need network information such as VPC ID, Subnet ID and create a SSH Key.
To ease the setup, you will use a script for settings of those parameters.
If you have time and are curious, you can examine the different steps of the script.

Retrieve the script.
```bash
curl -O https://raw.githubusercontent.com/aws-samples/awsome-hpc/main/apps/wrf/scripts/setup/SC22_create_parallelcluster_config.sh
```

Execute the script to retrieve network information.
```bash
chmod +x ./SC22_create_parallelcluster_config.sh
. ./SC22_create_parallelcluster_config.sh 
```

4. Store the SSH key in AWS Secrets Manager as a failsafe in the event that the private SSH key is lost

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
