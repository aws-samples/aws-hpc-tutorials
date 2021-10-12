+++
title = "b. Create your HPC Cluster"
date = 2019-09-18T10:46:30-04:00
weight = 30
tags = ["configuration", "FSx", "ParallelCluster"]
+++

In this step, you create a cluster configuration that includes parameters for Amazon FSx for Lustre.

{{% notice note %}}
If you are not familiar with AWS ParallelCluster, we recommend that you first complete the AWS ParallelCluster lab before proceeding.
{{% /notice %}}

#### Create an Amazon S3 Bucket and Upload Files

First, create an Amazon S3 bucket and upload a file. Then, you can retrieve the file using Amazon FSx for Lustre.

1. Open a terminal in your AWS Cloud9 instance.
2. Run the following commands to create a new Amazon S3 bucket. These commands also retrieve and store two example files in this bucket: [MatrixMarket](https://math.nist.gov/MatrixMarket/) and a velocity model from the [Society of Exploration Geophysicists](https://wiki.seg.org/wiki/SEG_C3_45_shot).

```bash
# generate a uniqe postfix
BUCKET_POSTFIX=$(uuidgen --random | cut -d'-' -f1)
echo "Your bucket name will be mybucket-${BUCKET_POSTFIX}"
aws s3 mb s3://mybucket-${BUCKET_POSTFIX}

# retrieve local copies
wget ftp://math.nist.gov/pub/MatrixMarket2/misc/cylshell/s3dkq4m2.mtx.gz
wget http://s3.amazonaws.com/open.source.geoscience/open_data/seg_eage_salt/SEG_C3NA_Velocity.sgy

# upload to your bucket
aws s3 cp s3dkq4m2.mtx.gz s3://mybucket-${BUCKET_POSTFIX}/s3dkq4m2.mtx.gz
aws s3 cp SEG_C3NA_Velocity.sgy s3://mybucket-${BUCKET_POSTFIX}/SEG_C3NA_Velocity.sgy

# delete local copies
rm s3dkq4m2.mtx.gz
rm SEG_C3NA_Velocity.sgy
```

Before continuing to the next step, check the content of your bucket using the AWS CLI with the command `aws s3 ls s3://mybucket-${BUCKET_POSTFIX}` or the [AWS console](https://s3.console.aws.amazon.com/s3/). Now, build our AWS ParallelCluster configuration.


#### Create a Cluster Configuration File for Amazon FSx for Lustre

This section assumes that you are familiar with AWS ParallelCluster and the process of bootstrapping a cluster.

Generate a new key-pair and new default AWS ParallelCluster configuration.

The cluster configuration that you generate for Amazon FSx for Lustre includes the following settings:

- Scratch Lustre partition of 1.2 TB; using the Amazon S3 bucket created previously as the import and export path.
  - There are two primary deployment options for Lustre, scratch or persistent. Scratch is best for temporary storage and shorter-term processing of data. There are two deployment options for Scratch, SCRATCH_1 and SCRATCH_2. SCRATCH_1 is the default deployment type. SCRATCH_2 is the latest generation scratch filesystem, and offers higher burst throughput over baseline throughput and also in-transit encryption of data.
- Set head node and compute nodes as [c5 instances](https://aws.amazon.com/ec2/instance-types/c5/). **C5** is the latest generation of compute-optimized instances. The head node has 4 vcpus and 8 GB of memory, perfect for scheduling jobs and compiling code. The compute instances have 72 vcpus and 144 GB of memory, perfect for compute intensive applications.
- A [placement group](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/placement-groups.html#placement-groups-cluster) to maximize the bandwidth between instances and reduce the latency.
- Set the cluster to 0 compute nodes when starting, the minimum size to 0, and maximum size to 8 instances. The cluster uses [Auto Scaling Groups](https://docs.aws.amazon.com/autoscaling/ec2/userguide/AutoScalingGroup.html) that will grow and shrink between the min and max limits based on the cluster utilization and job queue backlog.
- A [GP2 Amazon EBS](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AmazonEBS.html) volume will be attached to the head node then shared through NFS to be mounted by the compute nodes on */shared*. It is generally a good location to store applications or scripts. Keep in mind that the */home* directory is shared on NFS as well.
- The job scheduler is [SLURM](https://slurm.schedmd.com/overview.html)

{{% notice tip %}}
For more details about the configuration options, see the [AWS ParallelCluster User Guide](https://docs.aws.amazon.com/parallelcluster/latest/ug/what-is-aws-parallelcluster.html) and the [fsx parameters section](https://docs.aws.amazon.com/parallelcluster/latest/ug/fsx-section.html#fsx-kms-key-id) of the AWS ParallelCluster User Guide.
{{% /notice %}}

{{% notice note %}}
If you are using a different terminal than above, make sure that the Amazon S3 bucket name is correct.
{{% /notice %}}

Paste the following commands into your terminal:

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
key_name = ${SSH_KEY_NAME}
base_os = ${BASE_OS}
scheduler = ${SCHEDULER}
master_instance_type = c5.xlarge
s3_read_write_resource = *
vpc_settings = public
ebs_settings = myebs
queue_settings = compute
s3_read_resource = arn:aws:s3:::*

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
import_path =  s3://mybucket-${BUCKET_POSTFIX}
deployment_type = SCRATCH_2

[aliases]
ssh = ssh {CFN_USER}@{MASTER_IP} {ARGS}
EOF
```

If you want to check the content of your configuration file, use the following command:

```bash
cat my-cluster-config.ini
```


Now, you are ready to create a cluster.

#### Generate a Cluster for Amazon FSx for Lustre

Stop the cluster using the following command.

```bash
pcluster stop hpclab-yourname -r $AWS_REGION
```


Update the cluster using the following command

```bash
pcluster update hpclab-yourname -c my-cluster-config.ini -r $AWS_REGION
```

This cluster generates additional resources for Amazon FSx for Lustre which will take a few minutes longer to create than the previous AWS ParallelCluster workshop.

#### Connect to Your Cluster

Once updated, start and connect to your cluster.


```bash
pcluster start hpclab-yourname -r $AWS_REGION
```

```bash
pcluster ssh hpclab-yourname -i ~/.ssh/$SSH_KEY_NAME -r $AWS_REGION
```

Next, take a deeper look at the Lustre file system.
