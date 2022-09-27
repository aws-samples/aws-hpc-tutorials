---
title: "HPC on Kubernetes"
date: 2022-09-21T09:05:54Z
weight: 60
pre: "<b>Lab IV ⁃ </b>"
tags: ["HPC", "Overview", "Kubernetes"]
---

<!--
**HPC jobs on Kubernetes**
-->

{{% notice info %}}
This lab requires an AWS Cloud9 IDE. If you do not have an AWS Cloud9 IDE set up, complete the **[Prepartion](/02-aws-getting-started.html)** section of the workshop
{{% /notice %}}

{{% notice info %}}
This lab requires a Kubernetes cluster. If you are working on this lab as part of an AWS presented event, a cluster is already provisioned in your lab environment. If you do not have a cluster available, you can use the **[provision-eks-cluster](06-provision-eks-cluster)** instructions to provision a new cluster.
{{% /notice %}}


In this lab, you will learn how to use container orchestrators like AWS EKS and deploy an architecture for high-performance molecular dynamics. Specifically, you wil run a pipeline for modeling the molecular dynamics of lisozome in water ```Lowell TODO: ensure accuracy, expand as needed```, implemented with [Gromacs](https://www.gromacs.org/). 

You will be deploying the below architecture as part of this lab:

![AWS EKS](/images/aws-eks/lab4-intro-arch.png)

Outline of all steps in the lab:

- Clone `aws-do-eks` project

The `aws-do-eks` project is cloned in /home/ec2-user/aws-do-eks. Alternatively clone with the following command:
```
cd ~
git clone https://github.com/aws-samples/aws-do-eks
```

- Scale the cluster 

```
  CLUSTER_REGION=us-east-1 CLUSTER_NAME=eks-hpc nodegroup_name=c5n-18xl nodegroup_min=0 nodgroup_size=2 nodegroup_max=2 /eks/nodegroup/eks-nodegroup-scale.sh
```

- Deploy EFA device plugin

```
cd /eks/deployment/efa-device-plugin
./deploy.sh
```

- Setup an FSx volume

TODO: configure subnet and instance profile
```
cd /eks/deployment/csi/fsx
./deploy.sh
```

- Deploy Kubeflow MPI Operator
```
cd /eks/deplyment/kubeflow/mpi-operator
./deploy.sh
```

- Build and push `do-gromacs` container (or just reuse from Lab3)

```
cd /eks/deployment/hpc/do-gromacs
./build.sh
./push.sh
``` 

- Run unit tests

Unit tests of the do-gromacs container include OSU benchmarks to test network performance with and without EFA
```
cd /eks/deployment/hpc/do-gromacs
./test.sh
```

- Run Gromacs pipeline

```
cd /eks/deployment/hpc/do-gromacs
./exec.sh
./run-mpi.sh all
```

- Monitor pipeline execution (in parallel with above)

In a new shell cd ~/aws-do-eks; ./exec.sh

Monitor pods:
```
cd /eks/ops
kn gromacs
./watch-pods.sh
```

In a new shell cd ~/aws-do-eks; ./exec.sh
Monitor CPU utilization of node 1:
```
cd /eks/deployment/hpc/hyperthreading
./hyperthreading-disable.sh
cd /eks/deployment/htop
./deploy.sh
cd /eks/ops
./pod-exec.sh htop 1
htop
```

In a new shell cd ~/aws-do-eks; ./exec.sh
Monitor CPU utilization of node 2:
```
cd /eks/ops
./pod-exec.sh htop 2
htop
```

- Display results

Once the pipeline execution completes (status of prod job is Completed) the data is in FSx. 
If same FSx is not mounted to head node, get data to head node.
DCV into the head node, install and launch VMD, then visualize protein.

- Cleanup (Optional)

Delete FSx volume
```
cd /eks/deployment/csi/fsx
./delete.sh
```

Delete EKS cluster
```
cd /eks
./eks-delete.sh
```

