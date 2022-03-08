+++
title = "b. Create a Cluster Config"
date = 2019-09-18T10:46:30-04:00
weight = 40
tags = ["tutorial", "initialize", "ParallelCluster"]
+++

Now that you installed AWS ParallelCluster, let us create a cluster configuration file as below. Let us reuse the [**SSH key-pair**](/02-aws-getting-started/05-key-pair-create.html) created earlier.

Below are some details of the cluster configuration parameters/ settings:

- Head-node and compute nodes: [c5.xlarge instances](https://aws.amazon.com/ec2/instance-types/). You can change the instance type if you like, but you may run into EC2 limits that may prevent you from creating instances or create too many instances.
- In ParallelCluster 2.9 or above, we will support multiple instance types and multiple queues, but in this lab, we will only create one instance type and one queue.
- We use a [placement group](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/placement-groups.html#placement-groups-cluster) in this lab. A placement group will sping up instances close together inside one physical data center in a single Availability Zone to maximize the bandwidth and reduce the latency between instances.
- In this lab, the cluster has 0 compute nodes when starting and maximum size set to 8 instances.  AWS ParallelCluster will grow and shrink between the min and max limits based on the cluster utilization and job queue backlog.
- A [GP2 Amazon EBS](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AmazonEBS.html) volume will be attached to the head-node then shared through NFS to be mounted by the compute nodes on */shared*. It is generally a good location to store applications or scripts. Keep in mind that the */home* directory is shared on NFS as well.
- [SLURM](https://slurm.schedmd.com/overview.html) will be used as a job scheduler
- We disable Intel Hyper-threading by setting `DisableSimultaneousMultithreading: true` in the configuration file.

{{% notice tip %}}
For more details about the AWS ParallelCluster configuration options, see the [AWS ParallelCluster User Guide](https://docs.aws.amazon.com/parallelcluster/latest/ug/parallelcluster-version-3.html).
{{% /notice %}}


Execute the following commands in your cloud9 shell to get your AWS networking information and create a cluster configuration file:

```bash
IFACE=$(curl --silent http://169.254.169.254/latest/meta-data/network/interfaces/macs/)
SUBNET_ID=$(curl --silent http://169.254.169.254/latest/meta-data/network/interfaces/macs/${IFACE}/subnet-id)
VPC_ID=$(curl --silent http://169.254.169.254/latest/meta-data/network/interfaces/macs/${IFACE}/vpc-id)
REGION=$(curl --silent http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/[a-z]$//')
```

```yaml
cat > config.yaml << EOF
Region: ${REGION}
Image:
  Os: alinux2
SharedStorage:
  - MountDir: /shared
    Name: default-ebs
    StorageType: Ebs
HeadNode:
  InstanceType: c5.xlarge
  Networking:
    SubnetId: ${SUBNET_ID}
    ElasticIp: false
  Ssh:
    KeyName: lab-your-key
Scheduling:
  Scheduler: slurm
  SlurmQueues:
    - Name: compute
      CapacityType: ONDEMAND
      ComputeResources:
        - Name: compute
          InstanceType: c5.xlarge
          MinCount: 0
          MaxCount: 8
          DisableSimultaneousMultithreading: true
      Networking:
        SubnetIds:
          - ${SUBNET_ID}
        PlacementGroup:
          Enabled: true
EOF
```
Now, you are ready to launch a cluster! Proceed to the next section.
