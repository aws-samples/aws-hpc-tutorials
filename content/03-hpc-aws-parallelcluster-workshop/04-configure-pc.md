+++
title = "c. Create a Cluster Config"
date = 2019-09-18T10:46:30-04:00
weight = 50
tags = ["tutorial", "initialize", "ParallelCluster"]
+++

Now that you installed AWS ParallelCluster and created a default configuration, you can create a configuration file to build a simple HPC system. This file is generated in your home directory.

Generate the cluster with the following settings:

- Head-node and compute nodes: [c5.xlarge instances](https://aws.amazon.com/ec2/instance-types/). You can change the instance type if you like, but you may run into EC2 limits that may prevent you from creating instances or create too many instances.
- In ParallelCluster 2.9 or above, we will support multiple instance types and multiple queues, but in this lab, we will only create one instance type and one queue.
- We use a [placement group](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/placement-groups.html#placement-groups-cluster) in this lab. A placement group will sping up instances close together inside one physical data center in a single Availability Zone to maximize the bandwidth and reduce the latency between instances.
- In this lab, the cluster has 0 compute nodes when starting and maximum size set to 8 instances.  AWS ParallelCluster will grow and shrink between the min and max limits based on the cluster utilization and job queue backlog.
- A [GP2 Amazon EBS](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AmazonEBS.html) volume will be attached to the head-node then shared through NFS to be mounted by the compute nodes on */shared*. It is generally a good location to store applications or scripts. Keep in mind that the */home* directory is shared on NFS as well.
- [SLURM](https://slurm.schedmd.com/overview.html) will be used as a job scheduler
- We disable Intel Hyper-threading by setting `disable_hyperthreading = true` in the configuration file.

{{% notice tip %}}
For more details about the AWS ParallelCluster configuration options, see the [AWS ParallelCluster User Guide](https://docs.aws.amazon.com/parallelcluster/latest/ug/configuration.html).
{{% /notice %}}


For now, paste the following commands in your terminal:

```bash
export IFACE=$(curl --silent http://169.254.169.254/latest/meta-data/network/interfaces/macs/)
export SUBNET_ID=$(curl --silent http://169.254.169.254/latest/meta-data/network/interfaces/macs/${IFACE}/subnet-id)
export VPC_ID=$(curl --silent http://169.254.169.254/latest/meta-data/network/interfaces/macs/${IFACE}/vpc-id)
export REGION=$(curl --silent http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/[a-z]$//')
```
```bash
cd ~/environment
```

```bash
cat > my-cluster-config.ini << EOF
[aws]
aws_region_name = ${REGION}

[global]
cluster_template = default
update_check = false
sanity_check = true

[vpc public]
vpc_id = ${VPC_ID}
master_subnet_id = ${SUBNET_ID}

[cluster default]
key_name = pc-intro-key
base_os = alinux2
scheduler = slurm
master_instance_type = c5.xlarge
s3_read_write_resource = *
vpc_settings = public
ebs_settings = myebs
queue_settings = compute

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

[aliases]
ssh = ssh {CFN_USER}@{MASTER_IP} {ARGS}
EOF
```

Now, you are ready to launch a cluster! Proceed to the next section.
