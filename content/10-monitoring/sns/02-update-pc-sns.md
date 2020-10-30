+++
title = "a. Update IAM role Policy"
date = 2019-09-18T10:46:30-04:00
weight = 50
tags = ["tutorial", "Monitoring", "ParallelCluster", "SNS", "IAM"]
+++

In this section, we will re-use the cluster that was created in the earlier section for Grafana dashboard visualization and just update the policies to enable the cluster full SNS access. 

You just need to update the "additional_iam_policies" section as follows:

additional_iam_policies=arn:aws:iam::aws:policy/CloudWatchFullAccess,arn:aws:iam::aws:policy/AWSPriceListServiceFullAccess,arn:aws:iam::aws:policy/AmazonSSMFullAccess,arn:aws:iam::aws:policy/AWSCloudFormationReadOnlyAccess,**arn:aws:iam::aws:policy/AmazonSNSFullAccess**

In the AWS Cloud9 terminal, 








In [**Create an HPC Cluster**](/03-hpc-aws-parallelcluster-workshop.html) section of the workshop you learnt how to create a HPC Cluster using AWS ParallelCluster. In this section you will follow similar steps to create a cluster but also enable performance monitoring and dashboard visualization. 

But before creating the cluster you want to generate a new keypair for this lab and also query the network settings required for the cluster creation. 

The following commands generate a new keypair, query the EC2 metadata to get the Subnet ID, VPC ID.

{{% notice info %}}Don't skip this step, creating key-pair step is very important for the later steps, please follow instruction bellow.
{{% /notice %}}

Generate a new key-pair

```bash
aws ec2 create-key-pair --key-name lab-4-your-key --query KeyMaterial --output text > ~/.ssh/lab-4-key
```

```bash
chmod 600 ~/.ssh/lab-4-key
```

Getting your AWS networking information

```bash
IFACE=$(curl --silent http://169.254.169.254/latest/meta-data/network/interfaces/macs/)
SUBNET_ID=$(curl --silent http://169.254.169.254/latest/meta-data/network/interfaces/macs/${IFACE}/subnet-id)
VPC_ID=$(curl --silent http://169.254.169.254/latest/meta-data/network/interfaces/macs/${IFACE}/vpc-id)
REGION=$(curl --silent http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/[a-z]$//')
```

**Additional Security Group**

To visualize your Grafana dashboards from your browser you need to make sure that port 80 and port 443 of your head node are accessible from the internet (or form your network). You can achieve this by creating the appropriate security group via [AWS Management Console](https://aws.amazon.com/console/) or via [CLI](https://docs.aws.amazon.com/cli/index.html)

Create additonal security group and enable ports 80 and 443

```bash
GRAFANA_SG=$(aws ec2 create-security-group --group-name my-grafana-sg --description "Open Grafana dashboard ports" --vpc-id $VPC_ID --output text)
aws ec2 authorize-security-group-ingress --group-id $GRAFANA_SG --protocol tcp --port 443 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $GRAFANA_SG --protocol tcp --port 80 --cidr 0.0.0.0/0
```

**AWS ParallelCluster - Custom Bootstrap Actions**

AWS ParallelCluster can run arbitrary code either before (pre_install) or after (post_install) the main bootstrap action during cluster creation. In most cases, this code is stored in Amazon Simple Storage Service (Amazon S3) and accessed through an HTTPS connection. The code is executed as root and can be in any scripting language that is supported by the cluster OS. Often the code is in bash or python.

Post_install actions are called after the cluster bootstrap processes are complete. Post_install actions serve the last actions to occur before an instance is considered fully configured and complete. Some post_install actions include changing scheduler settings, modifying storage, and modifying packages.

You can pass argument to scripts by specifying them during configuration. For this, you pass them double-quoted to the post_install actions. 

{{% notice tip %}}
For more details about the AWS ParallelCluster configuration options, see the [AWS ParallelCluster User Guide](https://docs.aws.amazon.com/parallelcluster/latest/ug/configuration.html).
{{% /notice %}}

To setup monitoring and dashboard visualization using Prometheus and Grafana for your cluster you simply use a post_install script (**grafana-post-install.sh**) that is provided in the **aws-hpc-workshops** S3 bucket.
 
You can use this post_install script in the repo as it is, or customize it as you need. For instance, you might want to change your Grafana password to something more secure and meaningful for you, or you might want to customize some dashboards by adding additional components to monitor.

The proposed post_install script will take care of installing and configuring the different performance monitoring and dashboard visualization  components required for your cluster. Though, few additional parameters are needed in the AWS ParallelCluster config file: the post_install_args, additional IAM policies, security group.

For now, paste the following commands in your terminal:

```bash
cd ~/environment
```

```bash
cat > my-perf-cluster-config.ini << EOF
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
key_name = lab-4-your-key
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
instance_type = c5.large
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

Now, you are ready to launch a cluster with performance monitoring and dashboard visualization enabled! Proceed to the next section.
