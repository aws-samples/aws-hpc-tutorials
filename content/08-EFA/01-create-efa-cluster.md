---
title : "b. Create an HPC Cluster with EFA"
date: 2020-05-12T10:00:58Z
weight : 10
tags : ["configuration", "EFA", "ParallelCluster", "create"]
---

In this step, you create an HPC cluster configuration that includes parameters for Elastic Fabric Adapter (EFA).

{{% notice note %}}
Follow the instructions in the [Create an HPC Cluster](/05-create-cluster.html) lab before starting this section. We'll be using the cluster you created there.
{{% /notice %}}

When we setup the cluster we used the **hpc6a.48xlarge** instance which enables EFA automatically. The following two parameters are set:

* **EFA** true
* **Placement Group** true

You'll see them setup on the **Queue** section of the create cluster.

![Cluster Wizard](/images/pcluster/pcmanager-4.png)

No action needed in this step. For the next section [Connect to the cluster](/05-create-cluster/02-connect-cluster.html#ssm-connect).