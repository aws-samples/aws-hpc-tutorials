---
title: "Create an HPC Cluster"
date: 2019-01-24T09:05:54Z
weight: 30
pre: "<b>Lab I ⁃ </b>"
tags: ["HPC", "Overview"]
---
In this lab, you are introduced to [AWS ParallelCluster](https://aws.amazon.com/hpc/parallelcluster/) and will run a Weather forecast model (WRF) on the HPC Cluster on AWS. This workshop includes the following steps:

- Install and configure ParallelCluster on your AWS Cloud9 IDE.
- Create your first cluster.
- Submit a sample job and check what is happening in the background.
- Delete the cluster.

#### About Weather Research and Forecasting (WRF)
The [Weather Research and Forecasting (WRF) Model](https://ncar.ucar.edu/what-we-offer/models/weather-research-and-forecasting-model-wrf) is a next-generation mesoscale numerical weather prediction system designed for both atmospheric research and operational forecasting applications.
It features a dynamical core, a data assimilation system, and a software architecture supporting parallel computation and system extensibility.
The model serves a wide range of meteorological applications across scales from tens of meters to thousands of kilometers.

The effort to develop WRF began in the latter 1990's and was a collaborative partnership of the National Center for Atmospheric Research (NCAR), the National Oceanic and Atmospheric Administration (represented by the National Centers for Environmental Prediction (NCEP) and the Earth System Research Laboratory), the U.S. Air Force, the Naval Research Laboratory, the University of Oklahoma, and the Federal Aviation Administration (FAA).

WRF is a tightly coupled application that uses MPI and/or OpenMP.
In this lab, you will run WRF using only MPI.

### About AWS ParallelCluster

![hpc_logo](/images/hpc-aws-parallelcluster-workshop/aws-parallelclusterlogo.png)

[AWS ParallelCluster](https://aws.amazon.com/hpc/parallelcluster/) is an AWS-supported open source cluster management tool that makes it easy for you to deploy and manage High Performance Computing (HPC) clusters on AWS. ParallelCluster uses a simple text file to model and provision all the resources needed for your HPC applications in an automated and secure manner. It also supports a variety of job schedulers such as AWS Batch, SGE, Torque, and Slurm for easy job submissions.

AWS ParallelCluster is built on the popular open source CfnCluster project and is released via the Python Package Index (PyPI). ParallelCluster's source code is hosted on the Amazon Web Services repository on GitHub. AWS ParallelCluster is available at no additional charge, and you pay only for the AWS resources needed to run your applications.

### Benefits
#### Automatic Resource Scaling

With AWS ParallelCluster, you can use a simple text file to model, provision, and dynamically scale the resources needed for your applications in an automated and secure manner.

#### Easy Cluster Management
With AWS ParallelCluster you can provision resources in a safe, repeatable manner, allowing you to build and rebuild your infrastructure without the need for manual actions or custom scripts.

#### Seamless Migration to the Cloud
AWS ParallelCluster supports a wide variety of operating systems and batch schedulers so you can migrate your existing HPC workloads with little to no modifications.

### How It Works

![pcluster-arch](/images/hpc-aws-parallelcluster-workshop/pc-how-it-works.png)


{{% notice info %}}This lab requires an AWS Cloud9 IDE. If you do not have an AWS Cloud9 IDE set up, complete sections *a. Sign in to the Console* through *d. Work with the AWS CLI* in the **[Getting Started in the Cloud](/02-aws-getting-started.html)** workshop.
{{% /notice %}}
