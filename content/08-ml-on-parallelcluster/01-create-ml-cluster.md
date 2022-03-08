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

Let us reuse the [**SSH key-pair**](/02-aws-getting-started/05-key-pair-create.html) created earlier.

```bash
echo "export AWS_KEYPAIR=lab-your-key" >> ~/.bashrc
source ~/.bashrc
```

The cluster configuration that you generate for training large scale ML models includes constructs from EFA and FSx that you can explore in the previous sections of this workshop. The main additions to the cluster configuration script are:

- Set the compute nodes as [p3dn.24xlarge instances](https://aws.amazon.com/ec2/instance-types/). The p3dn.24xlarge is one of the [EFA supported instance types](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/efa.html#efa-instance-types) with multiple GPUs.
- Set the cluster initial size to 0 compute nodes and maximum size to 2 instances. The cluster uses [Auto Scaling Groups](https://docs.aws.amazon.com/autoscaling/ec2/userguide/AutoScalingGroup.html) that will grow and shrink between the min and max limits based on the cluster utilization and job queue backlog.
- Set the compute capacity type to be `CapacityType=SPOT`. [AWS EC2 Spot instances](https://aws.amazon.com/ec2/spot) are available for less than the cost of On-Demand Instances, but it is possible that they are interrupted. As the training workload provides model checkpointing - saving the model as training progresses - you will be able to restart training after a job failure. Consider running other compute capacity types in the case of limited spot instance availability or when running large scale training workloads that cannot be interrupted. Refer to [this documentation](https://docs.aws.amazon.com/parallelcluster/latest/ug/Scheduling-v3.html#yaml-Scheduling-SlurmQueues-CapacityType) to learn more about the impact of Spot instance interruptions in ParallelCluster.  
- Set the custom actions install script URL to the S3 path with the Conda configuration script. Also, you need to specify that ParallelCluster has access to this S3 bucket. Add following to the config:

```bash
CustomActions:
  OnNodeConfigured:
    Script: s3://mlbucket-${BUCKET_POSTFIX}/post-install.sh
Iam:
  S3Access:
    - BucketName: mlbucket-${BUCKET_POSTFIX}
```
- The selected job scheduler for this example is SLURM.

{{% notice tip %}}
For more details about the configuration options, see the [AWS ParallelCluster User Guide](https://docs.aws.amazon.com/parallelcluster/latest/ug/parallelcluster-version-3.html), the [EFA parameters ](https://docs.aws.amazon.com/parallelcluster/latest/ug/Scheduling-v3.html#yaml-Scheduling-SlurmQueues-ComputeResources-Efa) and the [FSx parameters](https://docs.aws.amazon.com/parallelcluster/latest/ug/SharedStorage-v3.html#SharedStorage-v3-FsxLustreSettings) sections of the AWS ParallelCluster User Guide.
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
```
```yaml
cat > ml-config.yaml << EOF
Region: ${REGION}
Image:
  Os: alinux2
SharedStorage:
  - MountDir: /shared
    Name: default-ebs
    StorageType: Ebs

  - Name: fsxshared
    StorageType: FsxLustre
    MountDir: /lustre
    FsxLustreSettings:
      StorageCapacity: 1200
      ImportPath: s3://mlbucket-${BUCKET_POSTFIX}
      DeploymentType: SCRATCH_2

HeadNode:
  InstanceType: c5n.2xlarge
  Networking:
    SubnetId: ${SUBNET_ID}
  Ssh:
    KeyName: ${AWS_KEYPAIR}
  Dcv:
    Emabled: true

Scheduling:
  Scheduler: slurm
  SlurmQueues:
    - Name: compute
      ComputeResources:
      - Name: p3dn24xlarge
        InstanceType: p3dn.24xlarge
        MinCount: 0
        MaxCount: 2
        DisableSimultaneousMultithreading: true
        Efa:
          Enabled: true
      CapacityType: SPOT
      CustomActions:
        OnNodeConfigured:
          Script: s3://mlbucket-${BUCKET_POSTFIX}/post-install.sh
      Iam:
        S3Access:
          - BucketName: mlbucket-${BUCKET_POSTFIX}
      Networking:
        SubnetIds:
          - ${SUBNET_ID}
        PlacementGroup:
          Enabled: true
EOF
```

If you want to check the content of your configuration file, use the following command:

```bash
cat ml-config.yaml
```

Now, you are ready to create your Distributed ML cluster.

#### Generate a Cluster for Machine Learning

Create the cluster using the following command. This process would take about 15 minutes (depending on the resources/ settings).

```bash
pcluster create-cluster --cluster-name ml-cluster -c ml-config.yaml
```

The cluster creation continues even if the terminal session you are on gets terminated. To check on the status of the creation, use the command: `pcluster describe-cluster --cluster-name ml-cluster`.

#### Connect to Your Cluster

Once created, connect to your cluster.

```bash
pcluster ssh --cluster-name ml-cluster -i ${AWS_KEYPAIR}.pem
```

Next, preprocess the training data.
