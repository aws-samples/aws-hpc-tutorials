---
title : "b. Create an HPC Cluster with EFA"
date: 2020-05-12T10:00:58Z
weight : 10
tags : ["configuration", "EFA", "ParallelCluster", "create"]
---

In this step, you create an HPC cluster configuration that includes parameters for Elastic Fabric Adapter (EFA).

{{% notice note %}}
If you are not familiar with AWS ParallelCluster, we recommend that you first complete the [AWS ParallelCluster lab](../03-hpc-aws-parallelcluster-workshop.html) before proceeding.
In particular, you need to follow the instructions to install AWS ParallelCluster: ```pip3 install aws-parallelcluster -U --user && pip3 install awscli -U --user```
{{% /notice %}}

#### Create a Cluster Configuration File for EFA

This section assumes that you are familiar with AWS ParallelCluster and the process of bootstrapping a cluster.

Let us reuse the [**SSH key-pair**](/02-aws-getting-started/05-key-pair-create.html) created earlier.

```bash
echo "export AWS_KEYPAIR=lab-your-key" >> ~/.bashrc
source ~/.bashrc
```

The cluster configuration that you generate for EFA includes the following:

- Set the compute nodes in a [Cluster Placement Group](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/placement-groups.html#placement-groups-cluster) to maximize the bandwidth and reduce the latency between instances.
- Set the compute nodes as [c5n.18xlarge instances](https://aws.amazon.com/ec2/instance-types/). You can change the instance type if you like, but you need to make sure you use one of the [EFA supported instance types](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/efa.html#efa-instance-types) .
- Set the cluster initial size to 0 compute nodes and maximum size to 8 instances. The cluster uses [Auto Scaling Groups](https://docs.aws.amazon.com/autoscaling/ec2/userguide/AutoScalingGroup.html) that will grow and shrink between the min and max limits based on the cluster utilization and job queue backlog.
- The selected job scheduler for this example is [SLURM](https://slurm.schedmd.com/overview.html)

{{% notice tip %}}
For more details about the configuration options, see the [AWS ParallelCluster User Guide](https://docs.aws.amazon.com/parallelcluster/latest/ug/what-is-aws-parallelcluster.html) and the [EFA parameters section](https://docs.aws.amazon.com/parallelcluster/latest/ug/Scheduling-v3.html#yaml-Scheduling-SlurmQueues-ComputeResources-Efa) of the AWS ParallelCluster User Guide.
{{% /notice %}}

```bash
# create the cluster configuration
IFACE=$(curl --silent http://169.254.169.254/latest/meta-data/network/interfaces/macs/)
SUBNET_ID=$(curl --silent http://169.254.169.254/latest/meta-data/network/interfaces/macs/${IFACE}/subnet-id)
VPC_ID=$(curl --silent http://169.254.169.254/latest/meta-data/network/interfaces/macs/${IFACE}/vpc-id)
AZ=$(curl http://169.254.169.254/latest/meta-data/placement/availability-zone)
REGION=${AZ::-1}
```

```yaml
cat > efa-config.yaml << EOF
Region: ${REGION}
Image:
  Os: alinux2
SharedStorage:
  - MountDir: /shared
    Name: default-ebs
    StorageType: Ebs

HeadNode:
  InstanceType: c5n.large
  Networking:
    SubnetId: ${SUBNET_ID}
  Ssh:
    KeyName: ${AWS_KEYPAIR}

Scheduling:
  Scheduler: slurm
  SlurmQueues:
    - Name: compute
      ComputeResources:
        - Name: c5n18xlarge
          InstanceType: c5n.18xlarge
          MinCount: 0
          MaxCount: 8
          DisableSimultaneousMultithreading: true
	  Efa:
	    Enabled: true
      Networking:
        SubnetIds:
          - ${SUBNET_ID}
        PlacementGroup:
          Enabled: true
EOF
```

If you want to check the content of your configuration file, use the following command:

```bash
cat efa-config.yaml
```


Now, you are ready to create your HPC cluster.

#### Generate a Cluster for with EFA enabled

Create the cluster using the following command. This process would take a few minutes.

```bash
pcluster create-cluster --cluster-name efa-cluster -c efa-config.yaml
```

#### Connect to Your Cluster

Once created, connect to your cluster.

```bash
pcluster ssh --cluster-name efa-cluster -i ${AWS_KEYPAIR}.pem
```

Next, take a deeper look at the EFA device.
