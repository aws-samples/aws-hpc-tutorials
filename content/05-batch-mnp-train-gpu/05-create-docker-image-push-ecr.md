---
title : "f. Create ECR, Build Image and Push"
date: 2022-07-22T15:58:58Z
weight : 60
tags : ["configuration", "vpc", "subnet", "iam", "pem"]
---

In this step, 
- create a registry in Elastic Container Registry
- push the images created by aws-do-docker for use during the training.

### Create ECR Registry
Create an ECR registry called g5_train using aws-cli

```bash
aws ecr create-repository --repository-name g5_train 
```

Upon successful creation, you get return json message that gives the arn of the repository

```json
aws ecr create-repository --repository-name g5_train 
{
    "repository": {
        "repositoryArn": "arn:aws:ecr:us-east-1:xxxxxxxx:repository/g5_train",
        "registryId": "0123456789",
        "repositoryName": "g5_train",
        "repositoryUri": "xxxxxxxxxx.dkr.ecr.us-east-1.amazonaws.com/g5_train",
        "createdAt": "2022-05-25T20:11:23+00:00",
        "imageTagMutability": "MUTABLE",
        "imageScanningConfiguration": {
            "scanOnPush": false
        },
        "encryptionConfiguration": {
            "encryptionType": "AES256"
        }
    }
}
```

### Build the Container


Download the [build_container.tar.gz](/scripts/batch_mnp/build_container.tar.gz) and upload it into your cloudshell environment

```bash
tar xzvf build_container.tar
```

The **build_container** folder has the aws-do-framework structure
- config.properties: Has the configurable parameters that needs to be set
- Dockerfile: to build the container
- Utility scripts: build.sh, run.sh, pull.sh, push.sh, stop.sh
- Container-Root: Relevant code and supervisord scripts to setup the container to be self discoverable and work in an mpi mode in the multi-node parallel setup

#### Update config.properties
```
registry=REGISTRY
registry_type=ecr
region=us-east-1
image_name=g5_train
image_tag=:v1
```
{{% notice info %}}
**Note: Strings inside properties file must not be quoted**
{{% /notice %}}

| PlaceHolder     	| Replace With                 	|
|-----------------	|------------------------------	|
| REGISTRY       	| xxxxxxxxx.dkr.ecr.us-east-1.amazonaws.com/(**Note: trailing /**) 	|

#### Build and Push the container

The utility scripts can be used to build and run the containers

```bash
./build.sh

Builds the container and takes around 5 - 10 minutes to build it

./push.sh
Logs into ECR and pushes the container
```
