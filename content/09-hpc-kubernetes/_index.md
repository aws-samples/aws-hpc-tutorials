---
title: "HPC on Kubernetes"
date: 2022-09-21T09:05:54Z
weight: 60x
pre: "<b>Lab IV ⁃ </b>"
tags: ["HPC", "Overview", "Kubernetes"]
---

{{% notice info %}}
This lab requires an AWS Cloud9 IDE. If you do not have an AWS Cloud9 IDE set up, complete the **[Prepartion](/02-aws-getting-started.html)** section of the workshop
{{% /notice %}}

In this lab, you are introduced to deploy and use a container orchestrator such as [Kubernetes](https://kubernetes.io/) for running HPC applications. You will run a high-performance application for molecular dynamics, [GROMACS](https://www.gromacs.org/), that reads and writes data from/to a managed Lustre parallel file system, Amazon FSx for Lustre.

The deployment of Kubernetes is a challenging endeavour when done on your own. In the cloud, managed services simplify the installation, operation, and maintenance of Kubernetes. [Amazon Elastic Kubernetes Service (Amazon EKS)](https://aws.amazon.com/eks/) is a managed Kubernetes service on AWS.

As part of this lab, you will deploy the below architecture to run GROMACS:

![AWS EKS](/images/aws-eks/eks-hpc-architecture.png)

Lab workflow:

- Provision Amazon EKS cluster
- Provision FSx for Lustre volume
- Setup monitoring
- Deploy Kubeflow MPI Operator
- Run EFA latency ping-pong test
- Run GROMACS MPI job
- Delete FSx volume and the EKS cluster
