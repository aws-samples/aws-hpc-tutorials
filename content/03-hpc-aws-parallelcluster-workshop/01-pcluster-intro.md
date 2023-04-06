+++
title = "a. About AWS ParallelCluster"
date = 2023-04-10T10:46:30-04:00
weight = 10
tags = ["tutorial", "ParallelCluster"]
+++

### About AWS ParallelCluster

![hpc_logo](/images/hpc-aws-parallelcluster-workshop/aws-parallelclusterlogo.png)

[AWS ParallelCluster](https://aws.amazon.com/hpc/parallelcluster/) is an open source cluster management tool that makes it easy for you to deploy and manage High Performance Computing (HPC) clusters on AWS. ParallelCluster uses a simple text file to model and provision all the resources needed for your HPC applications in an automated and secure manner. It also supports multiple instance types and job submission queues, and job schedulers like AWS Batch and Slurm.
 
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


{{% notice info %}} AWS ParallelCluster official documentation can be found [here](https://docs.aws.amazon.com/parallelcluster/). 
{{% /notice %}}

{{% notice info %}} AWS ParallelCluster Git-Hub repository is [here](https://github.com/aws/aws-parallelcluster).
{{% /notice %}}