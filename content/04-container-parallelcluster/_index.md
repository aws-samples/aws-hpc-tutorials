---
title: "Containers on AWS ParallelCluster"
date: 2019-01-24T09:05:54Z
weight: 40
pre: "<b>Lab II ⁃ </b>"
tags: ["HPC", "Overview"]
---

![ECS Logo](/images/container-pc/ecs-logo.png)

HPC Applications typically rely on several libraries and software components along with complex dependencies.
Those applications tend to be deployed on a shared file system for on-premise HPC system.
It can be challenging to share and deploy on a different HPC systems.
In the cloud, there are various ways to deploy an application: on a shared file system or an [Amazon Machine Image (AMI)](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html).
Shared file systems in the cloud tend to last for a short period of time, typically the length of job.
A machine image is a basic unit of deployment for Amazon EC2 instances and is another mechanism to deploy your application across many Amazon EC2 instances.
When the application will be modified with bug fixes or new features, you will need to create new machine with the new version of the application create a new EC2 instance using the new machine image.

Container has simplified the way groups develop, share and run software.
The growth of container technology has been mainly led by Docker which provides a way to package an application and its dependencies in a container that can run on a variety of locations, such as on-premises or in the cloud.
In HPC, the use of container mainly started in Life Science to address the growing number of software dependencies that computational bioinformatic applications have.
Many containers runtime for HPC has been created like [Singularity](https://sylabs.io/singularity/), [Shifter](https://www.nersc.gov/research-and-development/user-defined-images/), [CharlieCloud](https://hpc.github.io/charliecloud/) and [Sarus](https://sarus.readthedocs.io/en/stable/) which allow end-users to run containers in environments where Docker would not be feasible.
In addition, container enables to share with others the application easily and to deploy new version on existing EC2 instance without changing the machine image.


In this lab, you will create a container using Docker and use Singularity to run the container on your HPC cluster on AWS that you created in Lab I.
This lab includes the following steps:

- Modify your HPC cluster configuration file for AWS ParallelCluster
- Update your HPC cluster to install Docker, Singularity and provide access to [Amazon Elastic Container Registry (ECR)](https://aws.amazon.com/ecr/).
- Create your containerized application.
- Submit a sample job to run your containerized workload.
