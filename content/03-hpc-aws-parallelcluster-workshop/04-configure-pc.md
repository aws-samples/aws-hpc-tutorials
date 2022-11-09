+++
title = "d. Create a Cluster Config"
date = 2022-04-10T10:46:30-04:00
weight = 40
tags = ["tutorial", "initialize", "ParallelCluster"]
+++

Now that you installed AWS ParallelCluster and set up the foundation, you can create a configuration file to build a simple HPC Cluster. This file is generated in your home directory.

Generate the cluster with the following settings:

- Head-node and compute nodes: [m5.2xlarge and c5.18xlarge instances](https://aws.amazon.com/ec2/instance-types/c5/). You can change the instance type if you like, but you may run into EC2 limits that may prevent you from creating instances or create too many instances.
- AWS ParallelCluster (since version 2.9) supports multiple instance types and multiple queues.
- We use a [placement group](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/placement-groups.html#placement-groups-cluster) in this lab. A placement group will spin up instances close together, in a single network spine, inside one physical data center located in a specific Availability Zone to maximize the bandwidth and reduce the latency between instances.
- In this lab, the cluster has 0 compute nodes when starting and a maximum of 2 instances.  AWS ParallelCluster will grow and shrink between the min and max limits based on the cluster utilization and job queue backlog.
- A [GP3 Amazon EBS](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AmazonEBS.html) volume will be attached to the head-node then shared through NFS to be mounted by the compute nodes on `/shared`. It is generally a good location to store applications or scripts. Keep in mind that the `/home` directory is shared on NFS as well.
- [Slurm](https://slurm.schedmd.com/overview.html) is used as a job scheduler.
- We disable Intel Hyper-threading by setting `DisableSimultaneousMultithreading: true` in the configuration file.

{{% notice tip %}}
For more details about the AWS ParallelCluster configuration options, see the [AWS ParallelCluster User Guide](https://docs.aws.amazon.com/parallelcluster/latest/ug/cluster-configuration-file-v3.html).
{{% /notice %}}


For now, paste the following commands in your terminal:

#### 1. Source the env_vars file.
This makes sure all the required environment vairables from the previous section are set.

```bash
source env_vars
```

#### 2. You can have a look at them by running:

```bash
echo ${AWS_REGION}
echo ${INSTANCES}
echo ${SSH_KEY_NAME}
echo ${VPC_ID}
echo ${SUBNET_ID}
echo ${CUSTOM_AMI}
```

#### 3. Build the custom config file for ParallelCluster.

```bash
cat > my-cluster-config.yaml << EOF
HeadNode:
  InstanceType: m5.2xlarge
  Ssh:
    KeyName: ${SSH_KEY_NAME}
  Networking:
    SubnetId: ${SUBNET_ID}
  LocalStorage:
    RootVolume:
      Size: 50
  Iam:
    AdditionalIamPolicies:
      - Policy: arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore
  Dcv:
    Enabled: true
  Imds:
    Secured: true
Scheduling:
  Scheduler: slurm
  SlurmQueues:
    - Name: queue0
      ComputeResources:
        - Name: c524xl
          MinCount: 0
          MaxCount: 2
          InstanceType: c5.24xlarge
          DisableSimultaneousMultithreading: true
          Efa:
            Enabled: false
        - Name: c518xl
          MinCount: 0
          MaxCount: 2
          InstanceType: c5.18xlarge
          DisableSimultaneousMultithreading: true
          Efa:
            Enabled: false
      Networking:
        SubnetIds:
          - ${SUBNET_ID}
        PlacementGroup:
          Enabled: true
      ComputeSettings:
        LocalStorage:
          RootVolume:
            Size: 50
Region: ${AWS_REGION}
Image:
  Os: alinux2
  CustomAmi: ${CUSTOM_AMI}
SharedStorage:
  - Name: Ebs0
    StorageType: Ebs
    MountDir: /shared
    EbsSettings:
      VolumeType: gp3
      DeletionPolicy: Delete
      Size: '50'

EOF
```

Now, you are ready to launch a cluster! Proceed to the next section.
