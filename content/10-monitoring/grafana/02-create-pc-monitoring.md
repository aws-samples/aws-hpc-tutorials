+++
title = "a. Cluster Config with Monitoring setup"
date = 2019-09-18T10:46:30-04:00
weight = 10
tags = ["tutorial", "Monitoring", "ParallelCluster"]
+++

In [**Create an HPC Cluster**](/03-hpc-aws-parallelcluster-workshop.html) section of the workshop you learned how to create a HPC Cluster using AWS ParallelCluster. In this section you will follow similar steps to create a cluster with performance monitoring and dashboard visualization. 

Generate a new key-pair:

{{% notice info %}}Don't skip this step, creating key-pair step is very important for the later steps, please follow instruction bellow.
{{% /notice %}}

```bash
aws ec2 create-key-pair --key-name lab-4-your-key --query KeyMaterial --output text > ~/.ssh/lab-4-key
chmod 600 ~/.ssh/lab-4-key
```

Get your AWS networking information:

```bash
IFACE=$(curl --silent http://169.254.169.254/latest/meta-data/network/interfaces/macs/)
SUBNET_ID=$(curl --silent http://169.254.169.254/latest/meta-data/network/interfaces/macs/${IFACE}/subnet-id)
VPC_ID=$(curl --silent http://169.254.169.254/latest/meta-data/network/interfaces/macs/${IFACE}/vpc-id)
REGION=$(curl --silent http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/[a-z]$//')
```

### Additional Security Group

To visualize your Grafana dashboards from your browser we need to ensure port `80` and port `443` on the head node are accessible from the internet.

To do so we're going to create a security group and open those ports up:

```bash
GRAFANA_SG=$(aws ec2 create-security-group --group-name my-grafana-sg --description "Open Grafana dashboard ports" --vpc-id $VPC_ID --output text)
aws ec2 authorize-security-group-ingress --group-id $GRAFANA_SG --protocol tcp --port 443 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $GRAFANA_SG --protocol tcp --port 80 --cidr 0.0.0.0/0
```

### AWS ParallelCluster - Custom Bootstrap Actions

AWS ParallelCluster can run setup code either before (**pre_install**) or after (**post_install**) bootstrap during cluster creation. In most cases, this script is stored on Amazon S3 and downloaded through an HTTPS connection. The code is executed as root and can be in any scripting language that is supported by the cluster's OS. You can pass arguments to script by specifying them during configuration as **pre_install_args** or **post_install_args**.

{{% notice tip %}}
For more details about the AWS ParallelCluster configuration options, see the [AWS ParallelCluster User Guide](https://docs.aws.amazon.com/parallelcluster/latest/ug/configuration.html).
{{% /notice %}}

To setup monitoring and dashboard visualization using Prometheus and Grafana for your cluster we will use a **post_install** script (**grafana-post-install.sh**) that is provided in the **aws-hpc-workshops** S3 bucket. To examine this script, download it from here: https://aws-hpc-workshops.s3.amazonaws.com/grafana-post-install.sh

The following cluster configuration includes a **post_install** script that takes care of installing and configuring the performance monitoring and dashboard visualization components, in addition to the **post_install** script there's **additional_iam_policies**, **post_install_args** and the **security_group** created above. 

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

{{% notice tip %}}
You can use this **post_install** script in the repo as it is, or customize it as you need. For instance, you might want to change your Grafana password to something more secure and meaningful for you, or you might want to customize some dashboards by adding additional components to monitor.
{{% /notice %}}

Now, you are ready to launch a cluster with performance monitoring and dashboard visualization enabled! Proceed to the next section.
