---
title : "e. Create AWS Batch and Compute Environment"
date: 2022-07-22T15:58:58Z
weight : 50
tags : ["configuration", "vpc", "subnet", "iam", "pem"]
---

In this step, you will create AWS Batch Compute Environment and Job Queue using aws cli

### Creating the AWS Batch Compute Environment

The json configuration for the Compute Environment is given below
- copy the contents to a file called dl1_batch_ce.json and 
- edit the placeholder values

```json
{
  "computeEnvironmentName": "dl1_mnp_ce",
  "type": "MANAGED",
  "state": "ENABLED",
  "computeResources": {
    "type": "EC2",
    "minvCpus": 0,
    "maxvCpus": 64,
    "desiredvCpus": 0,
    "launchTemplate": {
      "launchTemplateId": "LAUNCH TEMPLATE",
      "version": "1"
    },
    "instanceTypes": [
      "dl1.24xlarge"
    ],
    "subnets": [
      "SUBNET"
    ],
    "ec2KeyPair": "PEM KEY NAME",
    "instanceRole": "INSTANCE ROLE",
    "tags": {
      "Name": "dl1_mnp_ce"
    }
  },
  "serviceRole": "arn:aws:iam::561120826261:role/service-role/AWSBatchServiceRole"
}

```

**Note: When you are entering strings inside JSON file, it has to be quoted for a valid json**

| PlaceHolder      	| Replace With                                                           	|
|------------------	|------------------------------------------------------------------------	|
| INSTANCE ROLE 	| `"arn:aws:iam::123456789012:instance-profile/ecsInstanceRole"` 	|
| LAUNCH TEMPLATE  	| `"lt-0123456789"`                                              	|
| SUBNET           	| `"subnet-0123456789"`                                         	|
| PEM KEY NAME     	| `"key_name"` w/o .pem extension                                          	|

After editing the placeholders, execute the command below to create the compute environment
```bash
aws batch create-compute-environment --cli-input-json file://dl1_batch_ce.json
```

### Create the AWS Job Queue

The json configuration for the Job Queue , 
- copy the contents to a file called dl1_batch_jq.json
- verify the default values which should reflect the names of the compute environment set above

```json
{
  "jobQueueName": "dl1_mnp_jq",
  "state": "ENABLED",
  "priority": 1,
  "computeEnvironmentOrder": [
    {
      "order": 1,
      "computeEnvironment": "dl1_mnp_ce"
    }
  ]
}
```
- Run the aws cli to create the job queue

```bash
aws batch create-job-queue --cli-input-json file://dl1_batch_jq.json
```