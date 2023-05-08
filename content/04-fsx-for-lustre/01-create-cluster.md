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

3. Select a **VPC** from your account. There should only be one VPN present if you have deleted the clusters from the previous labs.

![Cluster Wizard](/images/pcluster/pcmanager-2.png)

4. Select a **Keypair** from your account (optional).

![Cluster Wizard](/images/pcluster/pcmanager-3.png)

On the next page we show how to create a filesystem with AWS ParallelCluster.
