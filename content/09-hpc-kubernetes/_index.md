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
This lab requires an AWS Cloud9 IDE. If you do not have an AWS Cloud9 IDE set up, complete all of the steps in the **[Preparation](/02-aws-getting-started.html)** section of the workshop.
{{% /notice %}}

<!--
{{% notice info %}}
This lab requires a Kubernetes cluster. If you are working on this lab as part of an AWS presented event, a cluster is already provisioned in your lab environment. If you do not have a cluster available, you can use the **[provision-eks-cluster](06-provision-eks-cluster)** instructions to provision a new cluster.
{{% /notice %}}
-->

In this lab, you depoy and use a container orchestrator such as [Kubernetes](https://kubernetes.io/) for running HPC applications. You will run a high-performance application for molecular dynamics, [GROMACS](https://www.gromacs.org/), that reads and writes data from/to a managed Lustre parallel file system, [Amazon FSx for Lustre](https://aws.amazon.com/fsx/lustre/).

The deployment of Kubernetes is a challenging endeavour when done on your own. In the cloud, managed services simplify the installation, operation, and maintenance of Kubernetes. [Amazon Elastic Kubernetes Service (Amazon EKS)](https://aws.amazon.com/eks/) is a managed Kubernetes service on AWS.

### About Amazon EKS
Amazon EKS is is a managed service that you can use to run Kubernetes on AWS without needing to install, operate, and maintain your own Kubernetes control plane or nodes. In the cloud, Amazon EKS automatically manages the availability and scalability of the Kubernetes control plane nodes responsible for scheduling containers, managing application availability, storing cluster data, and other key tasks. With Amazon EKS, you can take advantage of all the performance, scale, reliability, and availability of AWS infrastructure, as well as integrations with AWS networking and security services. On-premises, [EKS Anywhere](https://aws.amazon.com/eks/eks-anywhere/) provides a consistent, fully-supported Kubernetes solution with integrated tooling and simple deployment to AWS Outposts, virtual machines, or bare metal servers.


As part of this lab, you will deploy the below architecture to run GROMACS:
![Architecture](/images/aws-eks/eks-hpc-architecture.png?width=50pc)

Lab workflow:

- Install CLIs
- Create Amazon EKS cluster
- Create FSx for Lustre volume
- Setup monitoring
- Deploy Kubeflow MPI Operator
- Run GROMACS MPI job
- Cleanup
- Homework
