---
title : "b. Create a distributed ML cluster"
date: 2020-09-04T15:58:58Z
weight : 10
tags : ["configuration", "ML", "ParallelCluster", "create", "cluster"]
---

In this step, you create a cluster configuration that supports your Distributed Machine Learning task.

{{% notice note %}}
If you are not familiar with AWS ParallelCluster, EFA and FSx, we recommend that you first complete the [AWS Amazon FSx for Lustre lab](../04-amazon-fsx-for-lustre.html) and [AWS EFA lab](../07-efa.html) before proceeding.
In particular, you need to be able to [examine the FSx file system](../04-amazon-fsx-for-lustre/03-check-fs.html) and [examine the EFA enabled instance](../07-efa/02-check-efa.html).
The use of [NICE DCV](https://aws.amazon.com/hpc/dcv/) to interact with the cluster through a remote desktop is optional. Check out the [Remote Visualization using NICE DCV lab](../06-nice-dcv.html) for more information.
{{% /notice %}}

#### Create a Cluster Configuration File

This section assumes that you are familiar with AWS ParallelCluster and the process of bootstrapping a cluster.

Generate a new key-pair and new default AWS ParallelCluster configuration.

```bash
# generate a new keypair, remove those lines if you want to use the previous one
aws ec2 create-key-pair --key-name lab-ml-key --query KeyMaterial --output text > ~/.ssh/lab-ml-key
chmod 600 ~/.ssh/lab-ml-key
```

The cluster configuration that you generate for training large scale ML models includes constructs from EFA and FSx that you can explore in the previous sections of this workshop. The main additions to the cluster configuration script are:

- Set the compute nodes as [p3dn.24xlarge instances](https://aws.amazon.com/ec2/instance-types/). The p3dn.24xlarge is currently the only available [EFA supported instance types](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/efa.html#efa-instance-types) with multiple GPUs.
- Set the cluster initial size to 0 compute nodes and maximum size to 2 instances. The cluster uses [Auto Scaling Groups](https://docs.aws.amazon.com/autoscaling/ec2/userguide/AutoScalingGroup.html) that will grow and shrink between the min and max limits based on the cluster utilization and job queue backlog.
- Set the compute cluster type to be `cluster_type=spot`. [AWS EC2 Spot instances](https://aws.amazon.com/ec2/spot) are available for less than the cost of On-Demand Instances, but it is possible that they are interrupted. As the training workload provides model checkpointing - saving the model as training progresses - you will be able to restart training after a job failure. Consider running other compute cluster types in the case of limited spot instance availability or when running large scale training workloads that cannot be interrupted. Refer to [this documentation](https://docs.aws.amazon.com/parallelcluster/latest/ug/spot.html) to learn more about the impact of Spot instance interruptions in ParallelCluster.  
- Set the post install script URL to the S3 path with the Conda configuration scrip: `post_install = s3://mlbucket-${BUCKET_POSTFIX}/post-install.sh`. You need to specify that ParallelCluster has the read-only right to this S3 bucket. Use the flag `s3_read_resource = arn:aws:s3:::mlbucket-${BUCKET_POSTFIX}*` to allow read access to all resources within `s3://mlbucket-${BUCKET_POSTFIX}`.
- The selected job scheduler for this example is SLURM.

{{% notice tip %}}
For more details about the configuration options, see the [AWS ParallelCluster User Guide](https://docs.aws.amazon.com/parallelcluster/latest/ug/what-is-aws-parallelcluster.html), the [EFA parameters ](https://docs.aws.amazon.com/parallelcluster/latest/ug/efa.html) and the [FSx parameters](https://docs.aws.amazon.com/parallelcluster/latest/ug/fsx-section.html) sections of the AWS ParallelCluster User Guide.
{{% /notice %}}

{{% notice note %}}
If you are using a different terminal than the previous section, make sure that the Amazon S3 bucket name is correct.
{{% /notice %}}

```bash
# create the cluster configuration
export IFACE=$(curl --silent http://169.254.169.254/latest/meta-data/network/interfaces/macs/)
export SUBNET_ID=$(curl --silent http://169.254.169.254/latest/meta-data/network/interfaces/macs/${IFACE}/subnet-id)
export VPC_ID=$(curl --silent http://169.254.169.254/latest/meta-data/network/interfaces/macs/${IFACE}/vpc-id)
export AZ=$(curl http://169.254.169.254/latest/meta-data/placement/availability-zone)
export REGION=${AZ::-1}


mkdir -p ~/.parallelcluster
cat > my-ml-cluster.ini << EOF
[aws]
aws_region_name = ${REGION}

[global]
cluster_template = default
update_check = false
sanity_check = true

[cluster default]
key_name = lab-ml-key
vpc_settings = public
base_os = alinux2
ebs_settings = myebs
fsx_settings = myfsx
compute_instance_type = p3dn.24xlarge
master_instance_type = c5.2xlarge
cluster_type = spot
placement_group = DYNAMIC
placement = compute
max_queue_size = 10
initial_queue_size = 0
disable_hyperthreading = true
scheduler = slurm
dcv_settings = default
scaling_settings = custom
s3_read_write_resource = arn:aws:s3:::mlbucket-${BUCKET_POSTFIX}*
post_install = s3://mlbucket-${BUCKET_POSTFIX}/post-install.sh
enable_efa = compute

[dcv default]
enable = master

[scaling custom]
scaledown_idletime = 15

[vpc public]
vpc_id = ${VPC_ID}
master_subnet_id = ${SUBNET_ID}

[ebs myebs]
shared_dir = /shared
volume_type = gp2
volume_size = 50

[fsx myfsx]
shared_dir = /lustre
storage_capacity = 1200
import_path =  s3://mlbucket-${BUCKET_POSTFIX}
deployment_type = SCRATCH_2

[aliases]
ssh = ssh {CFN_USER}@{MASTER_IP} {ARGS}
EOF
```

If you want to check the content of your configuration file, use the following command:

```bash
cat my-ml-cluster.ini
```

Now, you are ready to create your Distributed ML cluster.

#### Generate a Cluster for Machine Learning

Create the cluster using the following command. This process would take about 15 minutes.

```bash
pcluster create my-ml-cluster -c my-ml-cluster.ini
```

The cluster creation continues even if the terminal session you are on gets terminated. To check on the status of the creation, use the command: `pcluster status my-ml-cluster -c my-ml-cluster.ini`. If completed, the output would be something like this

![pcluster_create_output](/images/ml/pc_status.png)

#### Connect to Your Cluster

Once created, connect to your cluster.

```bash
pcluster ssh my-ml-cluster -i ~/.ssh/lab-ml-key
```

Next, preprocess the training data.
