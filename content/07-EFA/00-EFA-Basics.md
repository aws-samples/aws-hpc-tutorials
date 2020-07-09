---
title: "a. EFA Basics"
date: 2020-05-13T10:00:58Z
weight : 5
tags : ["EFA", "ParallelCluster", "basics",]

---

An [Elastic Fabric Adapter (EFA)](https://aws.amazon.com/hpc/efa/) is a network device that you can attach to your Amazon EC2 instance to accelerate High Performance Computing (HPC) and machine learning applications.
EFA enables you to achieve the application performance of an on-premises HPC cluster, with the scalability, flexibility, and elasticity provided by the AWS Cloud.

EFA provides lower and more consistent latency and higher throughput than the TCP transport traditionally used in cloud-based HPC systems.
It enhances the performance of inter-instance communication that is critical for scaling HPC and machine learning applications.
It is optimized to work on the existing AWS network infrastructure and it can scale depending on application requirements.

EFA supports the following interfaces and libraries: Open MPI 3.1.3 (and later) and Intel MPI 2019 Update 5 (and later), and Nvidia Collective Communications Library (NCCL) 2.4.2 (and later) for machine learning applications.

{{% notice note %}}
The OS-bypass capabilities of EFAs are not supported on Windows instances. If you attach an EFA to a Windows instance, the instance functions as an Elastic Network Adapter, without the added EFA capabilities.
{{% /notice %}}

#### EFA Basics

An EFA is an Elastic Network Adapter (ENA) with added capabilities. It provides all of the functionality of an ENA, with an additional OS-bypass functionality. OS-bypass is an access model that allows HPC and machine learning applications to communicate directly with the network interface hardware to provide low-latency, reliable transport functionality.

![EFA Stack](/images/efa/efa_stack.png)

Traditionally, HPC applications use the Message Passing Interface (MPI) to interface with the system’s network transport. In the AWS Cloud, this has meant that applications interface with MPI, which then uses the operating system's TCP/IP stack and the ENA device driver to enable network communication between instances.

With an EFA, HPC applications use MPI or NCCL to interface with the Libfabric API. The Libfabric API bypasses the operating system kernel and communicates directly with the EFA device to put packets on the network. This reduces overhead and enables the HPC application to run more efficiently.

{{% notice note %}}
Libfabric is a core component of the OpenFabrics Interfaces (OFI) framework, which defines and exports the user-space API of OFI. For more information, see the [Libfabric OpenFabrics website](https://ofiwg.github.io/libfabric/).
{{% /notice %}}


#### Differences between EFAs and ENAs

Elastic Network Adapters (ENAs) provide traditional IP networking features that are required to support VPC networking. EFAs provide all of the same traditional IP networking features as ENAs, and they also support OS-bypass capabilities. OS-bypass enables HPC and machine learning applications to bypass the operating system kernel and to communicate directly with the EFA device.


#### Supported interfaces and libraries

EFA supports the following interfaces and libraries:
- Open MPI 4.0.3
- Intel MPI 2019 Update 7
- NVIDIA Collective Communications Library (NCCL) 2.4.2 and later


#### EFA limitations

EFA has the following limitations:
- You can attach only one EFA per instance.
- EFA OS-bypass traffic is limited to a single subnet. In other words, EFA traffic cannot be sent from one subnet to another. Normal IP traffic from the EFA can be sent from one subnet to another.
- EFA OS-bypass traffic is not routable. Normal IP traffic from the EFA remains routable.
- The EFA must be a member of a security group that allows all inbound and outbound traffic to and from the security group itself.
