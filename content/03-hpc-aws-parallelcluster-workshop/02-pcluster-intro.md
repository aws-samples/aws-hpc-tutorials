+++
title = "a. About AWS ParallelCluster"
date = 2019-09-18T10:46:30-04:00
weight = 30
tags = ["tutorial", "install", "ParallelCluster"]
+++

![hpc_logo](/images/hpc-aws-parallelcluster-workshop/aws-parallelclusterlogo.png)

[AWS ParallelCluster](https://aws.amazon.com/hpc/parallelcluster/) is an AWS-supported open source cluster management tool that makes it easy for you to deploy and manage High Performance Computing (HPC) clusters on AWS. ParallelCluster uses a simple text file to model and provision all the resources needed for your HPC applications in an automated and secure manner. It also supports a variety of job schedulers such as AWS Batch and Slurm for easy job submissions.

AWS ParallelCluster is built on the popular open source CfnCluster project and is released via the Python Package Index (PyPI). ParallelCluster's source code is hosted on the Amazon Web Services repository on GitHub. AWS ParallelCluster is available at no additional charge, and you pay only for the AWS resources needed to run your applications.

#### Benefits

- **Automatic Resource Scaling**: With AWS ParallelCluster, you can use a simple text file to model, provision, and dynamically scale the resources needed for your applications in an automated and secure manner.
- **Easy Cluster Management**: With AWS ParallelCluster you can provision resources in a safe, repeatable manner, allowing you to build and rebuild your infrastructure without the need for manual actions or custom scripts.
- **Seamless Migration to the Cloud**: AWS ParallelCluster supports a wide variety of operating systems and batch schedulers so you can migrate your existing HPC workloads with little to no modifications.

#### How It Works

![pcluster-arch](/images/hpc-aws-parallelcluster-workshop/pc-how-it-works.png)


#### How does it work in practice?

You provide a configuration file to AWS ParallelCluster as shown below. AWS ParallelCluster will translate that into an AWS CloudFormation template that will deploy an HPC system based the settings you provided. This enable you to define specific cluster configurations for each application, for example one that needs GPUs and a high-performance parallel file system such as [Amazon FSx for Lustre](https://docs.aws.amazon.com/fsx/latest/LustreGuide/what-is.html) or define a cluster with CPU based instances such as [c5n.24xlarge](https://aws.amazon.com/ec2/instance-types/c5/) to process Computational Fluid Dynamics jobs.

One other key feature of AWS ParallelCluster is that you can connect to your cluster with [NICE DCV](https://docs.aws.amazon.com/dcv/latest/adminguide/what-is-dcv.html) to visualize your data [remotely](https://docs.aws.amazon.com/parallelcluster/latest/ug/dcv-v3.html) with a virtual desktop (no need to move your data back if there's no need)!

```bash
pcluster create-cluster --cluster-name my-cluster --cluster-configuration my-cluster-config.yaml --region ${AWS_REGION}
```

AWS ParallelCluster provides [several commands](https://docs.aws.amazon.com/parallelcluster/latest/ug/commands-v3.html) that you can use to manage your cluster such as listing your clusters and their instances, updating a cluster with a new configuration or shutting down a cluster.


#### What about Pcluster Manager

AWS ParallelCluster Manager is a project providing a Web User Interface for AWS ParallelCluster using the [AWS ParallelCluster API](https://docs.aws.amazon.com/parallelcluster/latest/ug/api-reference-v3.html). It enables you to create and manage your clusters through your web browser instead of your terminal and is entirely serverless. Authentication capabilities are provided via Amazon Cognito (which is why a valid email was needed to deploy the stacks).



