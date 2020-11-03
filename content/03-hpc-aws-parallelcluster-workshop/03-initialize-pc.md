+++
title = "b. Configure ParallelCluster"
date = 2019-09-18T10:46:30-04:00
weight = 40
tags = ["tutorial", "initialize", "ParallelCluster"]
+++


Typically, to configure AWS ParallelCluster, you use the command [**pcluster configure**](https://docs.aws.amazon.com/parallelcluster/latest/ug/getting-started-configuring-parallelcluster.html) and then provide the requested information, such as the AWS Region, Scheduler, and EC2 Instance Type. However, for this workshop you can take a shortcut by creating a basic configuration file, then customizing this file to include HPC specific options.

The following commands generate a new keypair, query the EC2 metadata to get the Subnet ID, VPC ID, and finally write a config to `~/.parallelcluster/config`. You can always edit this config file to add and change [configuration options](https://docs.aws.amazon.com/parallelcluster/latest/ug/configuration.html).

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

```bash
mkdir -p ~/.parallelcluster
```

Creating an initial AWS ParallelCluster config file

```bash
cat > ~/.parallelcluster/config << EOF
[aws]
aws_region_name = ${REGION}

[cluster default]
key_name = pc-intro-key
vpc_settings = public
base_os = alinux2
scheduler = slurm

[vpc public]
vpc_id = ${VPC_ID}
master_subnet_id = ${SUBNET_ID}

[global]
cluster_template = default
update_check = false
sanity_check = true

[aliases]
ssh = ssh {CFN_USER}@{MASTER_IP} {ARGS}
EOF
```

Now, check the content of this file using the following command:

```bash
cat ~/.parallelcluster/config
```

You now have a configuration file that allows you to create a simple cluster with the minimum required information. A default configuration file is good to have for testing purposes.

Next, you build a configuration to generate an optimized cluster to run typical "tightly coupled" HPC applications.
