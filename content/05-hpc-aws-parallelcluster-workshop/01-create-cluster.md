---
title: "a. Create a Cluster"
weight: 51
tags: ["tutorial", "cloud9", "ParallelCluster"]
---

![HPC6a Instance](/images/pcluster/hpc6a.png)

In this section we're going to use PCluster Manager to create a cluster from a sample template we've provided.

We'll be using the [hpc6a](https://aws.amazon.com/ec2/instance-types/hpc6/) instance, an AMD EPYC Milan based instance designed specifically for tightly coupled HPC style workloads. The instance has the following specs:

|  Instance Size | Cores | Memory (GiB) | EFA Network Bandwidth (Gbps) | Network Bandwidth (Gbps)* | On-Demand Price |
|:--------------:|:-----:|:------------:|:----------------------------:|:-------------------------:|-----------------|
| hpc6a.48xlarge |   96  |      384     |              100             |             25            | $2.88           |

1. Click **Create Cluster** Button

2. Name the cluster **hpc-cluster** and select **Template**. On the next step you'll be prompted to provide a file, download the template linked below and select that when prompted:

## [Download Template](/template/cluster-config.yml)

![Cluster Wizard](/images/pcluster/pcmanager-1.png)

On the next few screens, we'll modify the account specific components and leave the rest as specified by the template.

3. Select a **VPC** from your account

![Cluster Wizard](/images/pcluster/pcmanager-2.png)

4. Select a **Subnet**, ensuring the subnet is from the Availibility Zone ID **use2-az2**, and select a **Keypair** from your account (optional)

![Cluster Wizard](/images/pcluster/pcmanager-3.png)

4. Select the same **Subnet** from the previous step

![Cluster Wizard](/images/pcluster/pcmanager-4.png)

5. Click **Dry Run** to confirm the setup and then click **Create**

![Cluster Wizard](/images/pcluster/pcmanager-5.png)