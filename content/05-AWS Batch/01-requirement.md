+++
title = "b. Workshop Initial Setup"
date = 2019-09-18T10:46:30-04:00
weight = 20
tags = ["tutorial", "install", "AWS", "Batch"]
+++

The main account owner must complete the following steps for initial setup:

- Create an S3 bucket to store simulations outputs.
- Define an IAM role for Amazon ECS tasks to write the simulations output in that bucket.
- Build an Amazon EC2 role to access the S3 bucket where Nvidia drivers are stored.

The steps described above are completed using an AWS CloudFormation script and executed through the following commands. These commands must be executed on the main account using admin credentials in a terminal on Linux, OSX or WSL:

```bash
curl https://s3.amazonaws.com/aws-hpc-workshops/carla_0.9.5_ami_generation.zip \
     -o carla_0.9.5_ami_generation.zip
unzip carla_0.9.5_ami_generation.zip
pushd carla_0.9.5_ami_generation/utils
bash cfn_pre-requisites.sh
popd
```

The script waits until the base infrastructure is ready, then outputs the EC2 instance role needed to access the Nvidia drivers on Amazon S3.

{{% notice info %}}
Keep note of the following information for the next steps of the lab: **EC2 Role ID**, **ECS Task Role ID**, **ECS Job Execution Role ID**, and **S3 Bucket**.
{{% /notice %}}
