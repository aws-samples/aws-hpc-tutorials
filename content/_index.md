---
title: "AWS HPC Workshops"
date: 2019-09-18T10:50:17-04:00
draft: false
---
# Welcome to the Amazon Web Services HPC Workshops

Amazon Web Services provides the most elastic and scalable cloud infrastructure to run your [HPC applications](https://aws.amazon.com/hpc/). With AWS's virtually unlimited capacity, engineers, researchers, and HPC system owners can innovate beyond the limitations of on-premises HPC infrastructure.

AWS delivers an integrated suite of services that provides everything you need to quickly and easily build and manage HPC clusters in the cloud. With this elastic infrastructure you can run even your most compute-intensive workloads regardless of your industry and application.

Workloads running on AWS with the tools detailed in this workshop span both traditional HPC applications--genomics, computational chemistry, financial risk modeling, computer aided engineering, weather prediction, and seismic imaging--as well as emerging applications, such as machine learning, deep learning, and autonomous driving.

HPC on AWS removes the long wait times and lost productivity that can come from using fixed, on-premises HPC clusters. Flexible configuration and virtually unlimited scalability allow you to grow and shrink your infrastructure as your workloads dictate, not the other way around. Additionally, with access to a broad portfolio of cloud-based services like Data Analytics, Artificial Intelligence (AI), and Machine Learning (ML), you can redefine traditional HPC workflows to innovate faster.

Today, more HPC is run on AWS than on any other cloud.

#### What you will do in this workshop

In this workshop you will deploy and modify HPC clusters using the AWS ParallelCluster API. To exemplify how the API can be used, you will begin to use [PCluster Manager](https://github.com/aws-samples/pcluster-manager) which is an open-source project providing a Web UI on top of the AWS ParallelCluster API. In the second part of the workshop, you will directly interact with the AWS ParallelCluster API using its Python client.

To start with the workshop continue to [Workshop Overview](/01-hpc-overview.html).

#### About the AWS ParallelCluster API

AWS ParallelCluster API is a serverless application that once deployed to your AWS account will enable programmatic access to AWS ParallelCluster features via API.

AWS ParallelCluster API is distributed as a self-contained AWS CloudFormation template mainly consisting of an Amazon API Gateway endpoint, that exposes AWS ParallelCluster features, and an AWS Lambda function, that takes care of executing the invoked features.

The image below shows a high level architecture diagram of the AWS ParallelCluster API infrastructure.

![AWS ParallelCluster API Architecture](https://docs.aws.amazon.com/parallelcluster/latest/ug/images/API-Architecture.png)
