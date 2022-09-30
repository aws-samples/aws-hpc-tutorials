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

<!--
{{% notice info %}}
This lab requires a Kubernetes cluster. If you are working on this lab as part of an AWS presented event, a cluster is already provisioned in your lab environment. If you do not have a cluster available, you can use the **[provision-eks-cluster](06-provision-eks-cluster)** instructions to provision a new cluster.
{{% /notice %}}
-->

In this lab, you will learn how to use container orchestrators like **Amazon EKS** and deploy an architecture for high-performance molecular dynamics. Specifically, you will run a pipeline for modeling the molecular dynamics of lisozome in water ```Lowell TODO: ensure accuracy, expand as needed```, implemented with [Gromacs](https://www.gromacs.org/). 

You will be deploying the below architecture as part of this lab:

![AWS EKS](/images/aws-eks/eks-hpc-architecture.png)

Lab workflow:

1. [Provision EKS cluster](09-hpc-kubernetes/01-provision-eks.html)

2. [Provision FSx volume](09-hpc-kubernetes/02-provision-fsx.html)

3. [Setup monitoring](09-hpc-kubernetes/03-setup-monitoring.html)

4. [Deploy Kubeflow MPI Operator](09-hpc-kubernetes/04-mpi-operator.html)

5. [Run EFA tests](09-hpc-kubernetes/05-efa-tests.html)

6. [Run Gromacs MPI job](09-hpc-kubernetes/06-gromacs-mpi.html)

7. [Cleanup](09-hpc-kubernetes/07-cleanup.html)
