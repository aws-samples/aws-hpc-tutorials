+++
title = "c. Create a Cluster Config"
date = 2019-09-18T10:46:30-04:00
weight = 50
tags = ["tutorial", "initialize", "ParallelCluster"]
+++

Now that you installed AWS ParallelCluster and created a default configuration, you can create a configuration file to build a simple HPC system. This file is generated in your home directory.

Generate the cluster with the following settings:

- Head-node and compute nodes: [c4.xlarge instances](https://aws.amazon.com/ec2/instance-types/). You can change the instance type if you like, but you may run into EC2 limits that may prevent you from creating instances or create too many instances.
- We use a [placement group](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/placement-groups.html#placement-groups-cluster) to maximize the bandwidth between instances and reduce the latency. This packs instances close together inside an Availability Zone.
- The cluster has 0 compute nodes when starting and maximum size set to 8 instances. We are using [Auto Scaling Groups](https://docs.aws.amazon.com/autoscaling/ec2/userguide/AutoScalingGroup.html) that will grow and shrink between the min and max limits based on the cluster utilization and job queue backlog.
- A [GP2 Amazon EBS](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AmazonEBS.html) volume will be attached to the head-node then shared through NFS to be mounted by the compute nodes on */shared*. It is generally a good location to store applications or scripts. Keep in mind that the */home* directory is shared on NFS as well.
- SLURM will be used as a job scheduler but there are other options you may consider in the future such as SGE.
- We disable Intel Hyper-threading by setting `disable_hyperthreading = true` in the configuration file.

{{% notice tip %}}
For more details about the AWS ParallelCluster configuration options, see the [AWS ParallelCluster User Guide](https://docs.aws.amazon.com/parallelcluster/latest/ug/what-is-aws-parallelcluster.html).
{{% /notice %}}


For now, paste the following commands in your terminal:

```bash
IFACE=$(curl --silent http://169.254.169.254/latest/meta-data/network/interfaces/macs/)
SUBNET_ID=$(curl --silent http://169.254.169.254/latest/meta-data/network/interfaces/macs/${IFACE}/subnet-id)
VPC_ID=$(curl --silent http://169.254.169.254/latest/meta-data/network/interfaces/macs/${IFACE}/vpc-id)
REGION=$(curl --silent http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/[a-z]$//')

cd ~/environment
cat > my-cluster-config.ini << EOF
[aws]
aws_region_name = ${REGION}

[global]
cluster_template = default
update_check = false
sanity_check = true

[cluster default]
key_name = lab-3-your-key
base_os = alinux2
vpc_settings = public
ebs_settings = myebs
compute_instance_type = c4.xlarge
master_instance_type = c4.xlarge
cluster_type = ondemand
placement_group = DYNAMIC
placement = compute
initial_queue_size = 0
max_queue_size = 8
disable_hyperthreading = true
s3_read_write_resource = *
scheduler = slurm

[vpc public]
vpc_id = ${VPC_ID}
master_subnet_id = ${SUBNET_ID}

[ebs myebs]
shared_dir = /shared
volume_type = gp2
volume_size = 20

[aliases]
ssh = ssh {CFN_USER}@{MASTER_IP} {ARGS}
EOF
```

Now, you are ready to launch a cluster! Proceed to the next section.
