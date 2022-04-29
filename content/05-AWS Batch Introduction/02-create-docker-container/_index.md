---
title: "c. Build and upload your Container"
date: 2019-01-24T09:05:54Z
weight: 40
tags: ["HPC", "Batch", "Compute"]
---

In the previous steps, we have used AWS Cloudformation Templates to deploy both our VPC and Batch environments for us to run our tests. In this section, you will build the container image to be used in the test and upload it to Amazon ECR.

[stress-ng](https://kernel.ubuntu.com/~cking/stress-ng/) is used to simulate the behavior of a computational process for a duration of 10 minutes. You will create the image and upload it to Amazon ECR using one of the options below:

1. AWS Cloud9: use this option if you already have an AWS Cloud9 IDE.
2. Amazon EC2 instance: if you don't have an AWS Cloud9 environment or prefer to use a separate instance to build and push your container.


{{% notice info %}}
Currently, the AWS CloudShell compute environment doesn't support Docker containers. As a result, you will be unable to use AWS Cloudshell for the workshop. [Getting Started in the Cloud](https://docs.aws.amazon.com/cloudshell/latest/userguide/vm-specs.html) 
{{% /notice %}}
