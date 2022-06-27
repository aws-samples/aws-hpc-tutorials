---
title: "About AWS Batch"
date: 2022-06-27T09:05:54Z
weight: 10
---

## AWS Batch

[AWS Batch ](https://aws.amazon.com/batch/) enables developers, scientists, and engineers to easily and efficiently run hundreds of thousands of batch computing jobs on AWS. AWS Batch dynamically provisions the optimal quantity and type of compute resources (e.g., CPU or memory optimized instances) based on the volume and specific resource requirements of the batch jobs submitted. With AWS Batch, there is no need to install and manage batch computing software or server clusters that you use to run your jobs, allowing you to focus on analyzing results and solving problems. AWS Batch plans, schedules, and executes your batch computing workloads across the full range of AWS compute services and features, such as Amazon EC2 , AWS Fargate , and Amazon EC2 Spot pricing  for each.

There is no additional charge for AWS Batch. You only pay for the AWS resources you create to store data and run your batch jobs.

### Benefits
Fully managed
AWS Batch eliminates the need to operate third-party commercial or open source batch processing solutions. There is no batch software or servers to install or manage. AWS Batch manages all the infrastructure for you, avoiding the complexities of provisioning, managing, monitoring, and scaling your batch computing jobs.

### Integrated with AWS
AWS Batch is natively integrated with the AWS platform, allowing you to leverage the scaling, networking, and access management capabilities of AWS. This makes it easy to run jobs that safely and securely retrieve and write data to and from AWS data stores such as Amazon S3 or Amazon DynamoDB.

### Cost optimized resource provisioning
AWS Batch provisions compute resources and optimizes the job distribution based on the volume and resource requirements of the submitted batch jobs. AWS Batch dynamically scales compute resources to any quantity required to run your batch jobs, freeing you from the constraints of fixed-capacity clusters. AWS Batch will utilize Spot Instances on your behalf, reducing the cost of running your batch jobs further.


You can watch this video to quickly learn more about AWS Batch.
{{< youtube j_iI1DzSi5g >}}

<!-- Amazon Web Services (AWS) provides the most elastic and scalable cloud infrastructure to run your [High Performance Computing (HPC) applications](https://aws.amazon.com/hpc/). With virtually unlimited capacity, engineers, researchers, and HPC system owners can innovate beyond the limitations of on-premises HPC infrastructure.

AWS delivers an integrated suite of services that provides everything you need to quickly and easily build and manage HPC clusters in the cloud to run the most compute intensive workloads across various industry verticals.

These workloads span the traditional HPC applications, like genomics, computational chemistry, financial risk modeling, computer aided engineering, weather prediction, and seismic imaging, as well as emerging applications, like machine learning, deep learning, and autonomous driving.

HPC on AWS removes the long wait times and lost productivity often associated with on-premises HPC clusters. Flexible configuration and virtually unlimited scalability allow you to grow and shrink your infrastructure as your workloads dictate, not the other way around. Additionally, with access to a broad portfolio of cloud-based services like data analytics, artificial intelligence (AI), and machine learning (ML), you can redefine traditional HPC workflows to innovate faster.

Today, more cloud-based HPC applications run on AWS than on any other cloud. -->

Select a workshop from the left panel or just click and explore the workshops highlighted below.

This series of workshops is designed to get you familiar with the concepts and best practices to understand AWS components that help to build an HPC cluster and run your HPC workloads on HPC efficiently.

After an optional introduction and setup, you can walk through the following labs:

- Getting Started in the Cloud helps to familiarize you with the AWS Cloud.

- AWS ParallelCluster introduces you to running HPC workloads in the cloud.

- Amazon FSx for Lustre walks you through HPC focused services.

- AWS Batch teaches to you run a HPC application using the AWS managed service.

- Distributed ML explores how to leverage cloud HPC infrastructure to run data parallel training at scale.

We recommend you take these labs in the order presented as some dependencies exists between them, but feel free to change the order based on your comfort level.
