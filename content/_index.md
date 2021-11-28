---
title: "AWS HPC Workshops"
date: 2019-09-18T10:50:17-04:00
draft: false
---
# Welcome to the Amazon Web Services HPC Workshops: re:Invent 2021



Amazon Web Services provides the most elastic and scalable cloud infrastructure to run your [HPC applications](https://aws.amazon.com/hpc/). With AWS's virtually unlimited capacity, engineers, researchers, and HPC system owners can innovate beyond the limitations of on-premises HPC infrastructure.

AWS delivers an integrated suite of services that provides everything you need to quickly and easily build and manage HPC clusters in the cloud. With this elastic infrastructure you can run your most compute-intensive workloads regardless of your industry and application.

With the tools detailed in this workshop, you can run workloads on AWS spanning both traditional HPC applications--genomics, computational chemistry, financial risk modeling, computer aided engineering, weather prediction, and seismic imaging--as well as emerging applications, such as machine learning, deep learning, and autonomous driving.

HPC on AWS removes the long wait times and lost productivity that can come from using fixed, on-premises HPC clusters. Flexible configuration and virtually unlimited scalability allow you to grow and shrink your infrastructure as your workloads dictate, not the other way around. Additionally, with access to a broad portfolio of cloud-based services like Data Analytics, Artificial Intelligence (AI), and Machine Learning (ML), you can redefine traditional HPC workflows to innovate faster.

Today, more HPC is run on AWS than on any other cloud.

#### What you will do in this workshop

In this workshop you will deploy and modify HPC clusters using the AWS ParallelCluster API. To exemplify how the API can be used, you will begin to use [PCluster Manager](https://github.com/aws-samples/pcluster-manager) which is an open-source project providing a Web UI on top of the AWS ParallelCluster API. In the second part of the workshop, you will directly interact with the AWS ParallelCluster API using its Python client.

To start with the workshop continue to [Workshop Overview](/01-hpc-overview.html).

![hpc_logo](/images/hpc-aws-parallelcluster-workshop/aws-parallelclusterlogo.png)

#### What is AWS ParallelCluster

[AWS ParallelCluster](https://aws.amazon.com/hpc/parallelcluster/) is an AWS-supported, open source cluster management tool that makes it easy for you to deploy and manage High Performance Computing (HPC) clusters on AWS. ParallelCluster uses a simple (YAML) text file to model and provision all the resources needed for your HPC applications in an automated and secure manner. It also supports a variety of job schedulers such as AWS Batch and Slurm for easy job submissions.

AWS ParallelCluster is released via the Python Package Index (PyPI). ParallelCluster's source code is hosted on the [Amazon Web Services repository](https://github.com/aws/aws-parallelcluster) on GitHub. AWS ParallelCluster is available at no additional charge, and you pay only for the AWS resources you use to run your applications.

#### Benefits

- **Automatic Resource Scaling**: With AWS ParallelCluster, you can use a simple text file to model, provision, and dynamically scale the resources needed for your applications in an automated and secure manner.
- **Easy Cluster Management**: With AWS ParallelCluster you can provision resources in a safe, repeatable manner, allowing you to build and rebuild your infrastructure without the need for manual actions or custom scripts.
- **Seamless Migration to the Cloud**: AWS ParallelCluster supports a wide variety of operating systems and batch schedulers so you can migrate your existing HPC workloads with little to no modifications.

#### About the AWS ParallelCluster API

AWS ParallelCluster API is a serverless application that, once deployed to your AWS account, will enable programmatic access to AWS ParallelCluster features via API.

AWS ParallelCluster API is distributed as a self-contained AWS CloudFormation template mainly consisting of an Amazon API Gateway endpoint, that exposes AWS ParallelCluster features, and an AWS Lambda function, that takes care of executing the invoked features.

The image below shows a high level architecture diagram of the AWS ParallelCluster API infrastructure.

![AWS ParallelCluster API Architecture](https://docs.aws.amazon.com/parallelcluster/latest/ug/images/API-Architecture.png)
