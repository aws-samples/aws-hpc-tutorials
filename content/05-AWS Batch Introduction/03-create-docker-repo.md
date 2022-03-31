+++
title = "d. Build and upload your Container"
date = 2019-09-18T10:46:30-04:00
weight = 40
tags = ["tutorial", "install", "AWS", "batch", "Docker", "ECR"]
+++

[stress-ng](https://kernel.ubuntu.com/~cking/stress-ng/) is used to simulate the behavior of a computational process for a duration of 10 minutes. You will create the image and upload it to Amazon ECR using Docker on your workstation or an Amazon EC2 instance with Docker; a *t2.micro* instance is sufficient for this. Install docker by following [this guide](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/docker-basics.html#install_docker) and ensure that the pre-requisites shown on [this page](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/docker-basics.html#use-ecr) are fulfilled. Your instance needs to have the policy `AmazonEC2ContainerRegistryPowerUser` attached to its [IAM role](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/iam-roles-for-amazon-ec2.html).

Follow these steps to build the container image and upload it to Amazon ECR:

1. Create a new file called Dockerfile in your current working directory, open it, write the content below and save the file:


```bash
FROM public.ecr.aws/amazonlinux/amazonlinux:2
RUN amazon-linux-extras install epel -y && yum install stress-ng -y
CMD /usr/bin/stress-ng
```

2. If you are using an Amazon EC2 instance, run the commands below to build and push the container image to the Amazon ECR repository created when deploying the Batch CloudFormation stack. If running on your own workstation, ensure that the account ID and region are properly set for the environment variables `AWS_ACCOUNT_ID` and `AWS_REGION`. If further guidance is needed, follow this [guide](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/docker-basics.html#use-ecr).


```bash
#!/bin/bash

# set environment variables
AWS_ACCOUNT_ID=`curl -s http://169.254.169.254/latest/dynamic/instance-identity/document|grep accountId| awk '{print $3}'|sed  's/"//g'|sed 's/,//g'` # or replace by your account ID
AWS_REGION=`curl -s http://169.254.169.254/latest/dynamic/instance-identity/document|grep region| awk '{print $3}'|sed  's/"//g'|sed 's/,//g'` # or replace by your region ID
ECR_URL=`aws cloudformation describe-stacks --stack-name BatchStack --query "Stacks[0].Outputs[?OutputKey=='ECRRepositoryUrl'].OutputValue" --output text --region ${AWS_REGION}`

# Authenticate with ECR
aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

# Build the image
docker build -t stress-ng .

# Tag the image
docker tag stress-ng:latest ${ECR_URL}:latest

# Push your image to your ECR repository
docker push ${ECR_URL}:latest
```

By now, you should have

1. Deployed your network environment
2. Deployed your AWS Batch environment
3. created the container image that will be used to run your batch jobs.

You will now run a test workload in batch to evaluate its behavior.

