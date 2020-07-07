+++
title = "c. Create a Docker Repository"
date = 2019-09-18T10:46:30-04:00
weight = 40
tags = ["tutorial", "install", "AWS", "batch", "packer"]
+++

In this step, you create a Docker repository and upload a container image to this repository.

#### Create the Docker Repository

Use the AWS CLI create a Docker repository on Amazon ECR, the AWS managed container registry.

```bash
aws ecr create-repository --repository-name carla-av-demo
```

#### Fetch and Upload a Docker Image

Fetch the image from the web, then import it to your newly created ECR repository.

1. Fetch the docker credentials.
```bash
REGION=$(curl --silent http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/[a-z]$//')
$(aws ecr get-login --no-include-email --region ${REGION})
```
2. Import and tag the image.
```bash
# get the repository URI
ECR_REPOSITORY_URI=$(aws ecr describe-repositories --repository-names carla-av-demo --output text --query 'repositories[0].[repositoryUri]')
curl https://s3.amazonaws.com/av-workshop/carla-demo.tar -o carla-demo.tar
docker load -i carla-demo.tar
docker tag carla-demo:latest $ECR_REPOSITORY_URI
```
3. Push the image to the ECR repository.
```bash
docker push $ECR_REPOSITORY_URI:latest
```
