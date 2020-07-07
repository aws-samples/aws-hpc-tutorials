+++
title = "b. Install OpenFOAM"
date = 2019-09-18T10:46:30-04:00
weight = 30
tags = ["tutorial", "install", "AWS", "ParallelCluster", "OpenFOAM"]
+++

In this step, you create an Amazon Machine Image (AMI), the container, and then upload this container image to [Amazon Elastic Container Registry (Amazon ECR)](https://aws.amazon.com/ecr/) for later use with AWS Batch.

You must execute the following scripts in your terminal. Make sure that you have AWS CLI configured and that you have admin access on the account.

The following script builds an Amazon Elastic Container Service (Amazon ECS) compatible AMI with CARLA:

```bash
INSTANCE_ROLE=$(aws cloudformation describe-stacks --stack-name PrepAVWorkshop --output text --query 'Stacks[0].Outputs[?OutputKey == `S3RoleARN`].OutputValue')
pushd carla_0.9.5_ami_generation
bash build.sh $INSTANCE_ROLE
```

The building process is handled by [Packer](https://www.packer.io/) from HashiCorp. The process involves multiple reboots to update to the latest driver and kernel modules. We recommend that you to check the content of the file *image.json* while the AMI is building.
