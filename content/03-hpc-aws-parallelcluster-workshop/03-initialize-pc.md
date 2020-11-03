+++
title = "b. Configure ParallelCluster"
date = 2019-09-18T10:46:30-04:00
weight = 40
tags = ["tutorial", "initialize", "ParallelCluster"]
+++

The following commands generate a new key pair, query the EC2 metadata to get the Subnet ID, VPC ID. These will be used in the next section.

{{% notice info %}}Don't skip this step, creating key-pair step is very important for the later steps, please follow instruction bellow.
{{% /notice %}}

Generate a new key-pair

```bash
aws ec2 create-key-pair --key-name pc-intro-key --query KeyMaterial --output text > ~/.ssh/pc-intro-key
```

```bash
chmod 600 ~/.ssh/pc-intro-key
```

Getting your AWS networking information

```bash
export IFACE=$(curl --silent http://169.254.169.254/latest/meta-data/network/interfaces/macs/)
export SUBNET_ID=$(curl --silent http://169.254.169.254/latest/meta-data/network/interfaces/macs/${IFACE}/subnet-id)
export VPC_ID=$(curl --silent http://169.254.169.254/latest/meta-data/network/interfaces/macs/${IFACE}/vpc-id)
export REGION=$(curl --silent http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/[a-z]$//')
```

Next, you build a configuration to generate an optimized cluster to run typical "tightly coupled" HPC applications.
