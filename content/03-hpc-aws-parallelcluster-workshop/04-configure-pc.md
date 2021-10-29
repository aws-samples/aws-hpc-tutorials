+++
title = "c. Create a Cluster Config"
date = 2019-09-18T10:46:30-04:00
weight = 50
tags = ["tutorial", "initialize", "ParallelCluster"]
+++

Now that you installed AWS ParallelCluster and set up the foundation, you can create a configuration file to build a simple HPC system. This file is generated in your home directory.

Generate the cluster with the following settings:

- Head-node and compute nodes: [c5.xlarge instances](https://aws.amazon.com/ec2/instance-types/). You can change the instance type if you like, but you may run into EC2 limits that may prevent you from creating instances or create too many instances.
- AWS ParallelCluster 2.9 or above supports multiple instance types and multiple queues.
- We use a [placement group](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/placement-groups.html#placement-groups-cluster) in this lab. A placement group will sping up instances close together inside one physical data center in a single Availability Zone to maximize the bandwidth and reduce the latency between instances.
- In this lab, the cluster has 0 compute nodes when starting and a maximum of 2 instances.  AWS ParallelCluster will grow and shrink between the min and max limits based on the cluster utilization and job queue backlog.
- A [GP2 Amazon EBS](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AmazonEBS.html) volume will be attached to the head-node then shared through NFS to be mounted by the compute nodes on `/shared`. It is generally a good location to store applications or scripts. Keep in mind that the `/home` directory is shared on NFS as well.
- [SLURM](https://slurm.schedmd.com/overview.html) is used as a job scheduler
- We disable Intel Hyper-threading by setting `disable_hyperthreading = true` in the configuration file.

{{% notice tip %}}
For more details about the AWS ParallelCluster configuration options, see the [AWS ParallelCluster User Guide](https://docs.aws.amazon.com/parallelcluster/latest/ug/configuration.html).
{{% /notice %}}


For now, paste the following commands in your terminal:

1. Let us first makes sure all the required environment vairables from the previous section are set (if any of these commands return a null please go to step 2 and set the variables from the env_vars file generated previously)

```bash
echo $AWS_REGION
echo $SUBNET_ID
echo $SSH_KEY_NAME
```

2. In case any of the above environment variables are not set, source it from the **env_vars** file generated in your working directory previously

```bash
source env_vars
```

3. Retrieve NCAR WRF v4 AMI

NCAR provides an Amazon Machine Image (AMI) that contains a compiled version of WRF v4.
You will leverage this AMI to run WRF on a test case in the next section of this lab.

```bash
CUSTOM_AMI=`aws ec2 describe-images --owners 111992169430 \
    --query 'Images[*].{ImageId:ImageId,CreationDate:CreationDate}' \
    --filters "Name=name,Values=*-amzn2-parallelcluster-2.11.2-wrf-4.2.2-*" \
    --region ${AWS_REGION} \
    | jq -r 'sort_by(.CreationDate)[-1] | .ImageId'`

echo "export CUSTOM_AMI=${CUSTOM_AMI}" >> env_vars
```


4. Build the custom config file for ParallelCluster

```bash
cat > my-cluster-config.ini << EOF
[vpc public]
vpc_id = ${VPC_ID}
master_subnet_id = ${SUBNET_ID}

[global]
cluster_template = default
update_check = true
sanity_check = true

[cluster default]
key_name = ${SSH_KEY_NAME}
base_os = alinux2
scheduler = slurm
master_instance_type = c5.xlarge
master_root_volume_size = 40
compute_root_volume_size = 40
additional_iam_policies = arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore, arn:aws:iam::aws:policy/service-role/AmazonSSMMaintenanceWindowRole
vpc_settings = public
ebs_settings = myebs
queue_settings = c5n18large
custom_ami = ${CUSTOM_AMI}

[queue c5n18large]
compute_resource_settings = c5n18large
disable_hyperthreading = true
enable_efa = true
placement_group = DYNAMIC

[compute_resource c5n18large]
instance_type = c5n.18xlarge
min_count = 0
max_count = 2

[ebs myebs]
shared_dir = /shared
volume_type = gp2
volume_size = 20

[aliases]
ssh = ssh {CFN_USER}@{MASTER_IP} {ARGS}
EOF
```

Now, you are ready to launch a cluster! Proceed to the next section.
