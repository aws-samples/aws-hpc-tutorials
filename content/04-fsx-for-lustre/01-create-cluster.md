+++
title = "a. Create HPC Cluster"
date = 2019-09-18T10:46:30-04:00
weight = 10
tags = ["configuration", "FSx", "ParallelCluster"]
+++

#### Create HPC Cluster

In this section we're going to use ParallelCluster UI to create a cluster and file system.

1. Click **Create Cluster** Button

2. Name the cluster **hpc-cluster** and select **Template**. On the next step you'll be prompted to provide a file, download the template linked below and select that when prompted:

{{% button href="/template/cluster-config-fsx.yml" icon="fas fa-save" %}}Download Template{{% /button %}}

![Cluster Wizard](/images/pcluster/pcmanager-1.png)

On the next few screens, we'll modify the account specific components and leave the rest as specified by the template.

3. Select a **VPC** from your account. There should only be one VPC present if you have deleted the clusters from the previous labs.

![Cluster Wizard](/images/pcluster/lab2-selectVPC.jpg)

4. Select a **Keypair** from your account. This can be an existing `lab-your-key` in your Cloud9 instance. It can also be the `ws-default-keypair` that was automatically provided by Workshop Studio. You will not require a keypair when using ParallelCluster UI.
5. By choosing a **Subnet** you are implicitly selecting an Availability Zone (AZ), note your Subnet or AZ to choose the same Subnet in the Compute Queue configuration.

![Cluster Wizard](/images/pcluster/lab2-selectHeadNode.jpg)

On the next page we show how to create a filesystem with AWS ParallelCluster.
