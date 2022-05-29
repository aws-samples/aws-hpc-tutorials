+++
title = "b. Update your cluster"
date = 2019-09-18T10:46:30-04:00
weight = 30
tags = ["tutorial", "update", "ParallelCluster"]
+++

In this section, you will update the configuration of the HPC cluster you created in [Lab I](03-hpc-aws-parallelcluster-workshop.html) to:
- Add a script to install Docker and Singularity.
- Provide access to the container registry, [Amazon Elastic Container Registry (ECR)](https://aws.amazon.com/ecr/).
- Create a new queue that will be used to run the containerized workload.
- Update the configuration of the HPC Cluster.

#### 1. Edit Cluster

Click on the **Edit** button in Pcluster Manager.

![Edit button](/images/container-pc/edit.png)

#### 2. HeadNode

The first screen leave it as is, next advance to the **HeadNode** tab.

On the HeadNode tab add permission to access the [Amazon Elastic Container Registry (ECR)](https://aws.amazon.com/ecr/) by adding the managed `AmazonEC2ContainerRegistryFullAccess` [AWS IAM](https://aws.amazon.com/iam/) policy.

1. Click the drop down on the **Advanced options**.
2. Click the drop down on **IAM Policies**.
3. Add in the policy `arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess`. Click Add.

![HeadNode IAM](/images/container-pc/headnode-iam.png)

#### 3. Queue Configuration

Click next twice to advance to the **Queues section**, here we're going to add a queue that has Docker and Singularity installed on the compute nodes. 

1. Choose **Add Queue**.
2. Set the **Subnet** to the same subnet as the first queue (queue1).
3. Set the **Dynamic Nodes** to `8`.
4. Set the **Instance Type** to `c5.xlarge`.

![Queue Edit](/images/container-pc/queue-edit.png)

Next add in a script that installs Docker and Singularity on the Compute Nodes.

1. Dropdown **Advanced Options** on the queue you just created.
2. Paste in the following url into **On Configured** section `https://raw.githubusercontent.com/aws-samples/aws-hpc-tutorials/isc22/static/scripts/post-install/container-install.sh`.
3. Expand **IAM Policies** and paste in the following policy `arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess`. Click Add.
4. Click **Next** to continue to the **Update** section.

![Advanced Options](/images/container-pc/queue-iam.png)

#### 4. Increase RootVolume Size of your cluster

In the cluster's config add the following snippet at the bottom of the `queue1` section, `line 56`:

```yaml
ComputeSettings:
  LocalStorage:
    RootVolume:
      Size: 50
```

![Add in LocalStorage](/images/container-pc/localstorage-edit.png)

#### 5. Update your HPC Cluster

On the next screen confirm the cluster configuration and update the cluster.

1. Click **Stop Compute Fleet** and click to confirm, this will take a minute to complete, wait to run the update until it's stopped.
2. **Dryrun** to validate the cluster configuration. You'll see three warnings that you can safely ignore.
3. Run **Update**

![Update Cluster](/images/container-pc/update-cluster.png)

Once we've ran the update we'll be redirected to the main pcluster console screen where we can view update progress.

If the update doesn't succeed check the contents of the cluster configuration file looks similar to the below. If you are missing anything, review the steps above.

```yaml
HeadNode:
  InstanceType: m5.2xlarge
  Ssh:
    KeyName: hpc-lab-key
  Networking:
    SubnetId: subnet-123456789
  LocalStorage:
    RootVolume:
      Size: 50
  Iam:
    AdditionalIamPolicies:
      - Policy: arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore
      - Policy: arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess
  Dcv:
    Enabled: true
  Imds:
    Secured: true
Scheduling:
  Scheduler: slurm
  SlurmQueues:
    - Name: queue0
      ComputeResources:
        - Name: queue0-c5n18xlarge
          MinCount: 0
          MaxCount: 2
          InstanceType: c5n.18xlarge
          DisableSimultaneousMultithreading: true
          Efa:
            Enabled: true
            GdrSupport: true
      Networking:
        SubnetIds:
          - subnet-123456789
        PlacementGroup:
          Enabled: true
      ComputeSettings:
        LocalStorage:
          RootVolume:
            Size: 50
    - Name: queue1
      ComputeResources:
        - Name: queue1-c5xlarge
          MinCount: 0
          MaxCount: 8
          InstanceType: c5.xlarge
      Networking:
        SubnetIds:
          - subnet-123456789
      CustomActions:
        OnNodeConfigured:
          Script: >-
            https://github.com/aws-samples/aws-hpc-tutorials/blob/isc22/static/scripts/post-install/container-install.sh
      Iam:
        AdditionalIamPolicies:
          - Policy: arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess
      ComputeSettings:
        LocalStorage:
          RootVolume:
            Size: 50
Region: eu-west-1
Image:
  Os: alinux2
  CustomAmi: ami-0975de9b755cc2d78
SharedStorage:
  - Name: Ebs0
    StorageType: Ebs
    MountDir: /shared
    EbsSettings:
      VolumeType: gp2
      DeletionPolicy: Delete
      Size: '50'
```
