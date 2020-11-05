+++
title = "a. Cluster configuration"
date = 2019-09-18T10:46:30-04:00
weight = 10
tags = ["tutorial", "Monitoring", "ParallelCluster"]
+++

In [**Create an HPC Cluster**](/03-hpc-aws-parallelcluster-workshop.html) section of the workshop you learned how to create a HPC Cluster in the Cloud using AWS ParallelCluster. In this section, you will create a HPC cluster with system telemetry that will provide system monitoring and performance dashboard in Grafana.

{{% notice info %}}This lab requires an AWS Cloud9 IDE. If you do not have an AWS Cloud9 IDE set up, complete sections *a. Sign in to the Console* through *d. Work with the AWS CLI* in the [**Lab Prep**](/02-aws-getting-started.html) workshop.
{{% /notice %}}

First, let's upgrade the AWS CLI and install AWS ParallelCluster:

```bash
pip-3.6 install awscli -U --user
pip-3.6 install aws-parallelcluster -U --user
```

Then on your Cloud9 instance, run the following to generate a new key-pair:

{{% notice warning %}}Don't skip this step, creating key-pair step is very important for the later steps, please follow instruction below.
{{% /notice %}}

```bash
aws ec2 create-key-pair --key-name lab-4-key --query KeyMaterial --output text > ~/.ssh/lab-4-key
chmod 600 ~/.ssh/lab-4-key
```

Next, collect environment information for later use:

```bash
IFACE=$(curl --silent http://169.254.169.254/latest/meta-data/network/interfaces/macs/)
SUBNET_ID=$(curl --silent http://169.254.169.254/latest/meta-data/network/interfaces/macs/${IFACE}/subnet-id)
VPC_ID=$(curl --silent http://169.254.169.254/latest/meta-data/network/interfaces/macs/${IFACE}/vpc-id)
REGION=$(curl --silent http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/[a-z]$//')
echo """IFACE=$IFACE
SUBNET_ID=$SUBNET_ID
VPC_ID=$VPC_ID
REGION=$REGION"""
```

### Additional Security Group

To visualize your Grafana dashboards from your browser you need to ensure port `80` and port `443` on the master node are accessible from the internet. A [security group](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html) acts as a virtual firewall for your instance to control inbound and outbound traffic.

Create the security group and open ports `80` and `443`:

```bash
GRAFANA_SG=$(aws ec2 create-security-group --group-name my-grafana-sg --description "Open Grafana dashboard ports" --vpc-id $VPC_ID --output text)
aws ec2 authorize-security-group-ingress --group-id $GRAFANA_SG --protocol tcp --port 443 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $GRAFANA_SG --protocol tcp --port 80 --cidr 0.0.0.0/0
```

### AWS ParallelCluster - Custom Bootstrap Actions

AWS ParallelCluster can run user-provided *pre-install* or *post-install* scripts that will be executed respectively before or after the main bootstrap. As an example, network configuration, block storage device setup are usually done in *pre-install* stage, while the setting up users, installing packages in the *post-install* stage. You can store these scripts on Amazon S3 and download them through an HTTPS connection. The code is executed as root and can be in any scripting language that is supported by the cluster's OS. Arguments to these scripts can be specified as *pre_install_args* or *post_install_args* in the cluster's configuration.

{{% notice tip %}}
For more details about the AWS ParallelCluster pre-install and post-install scripts, see the [AWS ParallelCluster Custom Bootstrap Options](https://docs.aws.amazon.com/parallelcluster/latest/ug/pre_post_install.html).
{{% /notice %}}

To setup monitoring and dashboard visualization using Prometheus and Grafana for your cluster we will use a `post_install` script (`grafana-post-install.sh`) that is provided in the **aws-hpc-workshops** S3 bucket. This script sets up custom dashboards and metrics on the cluster. To examine this script, download it from here: https://aws-hpc-workshops.s3.amazonaws.com/grafana-post-install.sh

The following cluster configuration includes a *post_install* script that takes care of installing and configuring the system monitoring and performance dashboard, in addition to the *post_install* script there's *additional_iam_policies*, *post_install_args* and the *security_group* created above. 

```ini
cat > ~/environment/my-perf-cluster-config.ini << EOF
[aws]
aws_region_name = ${REGION}

[global]
cluster_template = default
update_check = false
sanity_check = true

[vpc public]
vpc_id = ${VPC_ID}
master_subnet_id = ${SUBNET_ID}
additional_sg = ${GRAFANA_SG}

[cluster default]
key_name = lab-4-key
base_os = alinux2
scheduler = slurm
master_instance_type = c5.xlarge
s3_read_write_resource = *
vpc_settings = public
fsx_settings = myfsx
ebs_settings = myebs
queue_settings = compute
post_install = s3://aws-hpc-workshops/grafana-post-install.sh
post_install_args = https://aws-hpc-workshops.s3.amazonaws.com/master.zip
additional_iam_policies=arn:aws:iam::aws:policy/CloudWatchFullAccess,arn:aws:iam::aws:policy/AWSPriceListServiceFullAccess,arn:aws:iam::aws:policy/AmazonSSMFullAccess,arn:aws:iam::aws:policy/AWSCloudFormationReadOnlyAccess

[queue compute]
compute_resource_settings = default
disable_hyperthreading = true
placement_group = DYNAMIC

[compute_resource default]
instance_type = c5.xlarge
min_count = 0
max_count = 8

[ebs myebs]
shared_dir = /shared
volume_type = gp2
volume_size = 20

[fsx myfsx]
shared_dir = /lustre
storage_capacity = 1200
deployment_type = SCRATCH_2

[aliases]
ssh = ssh {CFN_USER}@{MASTER_IP} {ARGS}
EOF
```

{{% notice tip %}}
You can use this **post_install** script in the repo as it is, or customize it as you need. For instance, you might want to change your Grafana password to something more secure and meaningful for you, or you might want to customize some dashboards by adding additional components to monitor.
{{% /notice %}}

Now, you are ready to launch a cluster with performance monitoring and dashboard visualization enabled.
