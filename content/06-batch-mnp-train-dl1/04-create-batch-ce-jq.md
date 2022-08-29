---
title : "e. Create AWS Batch and Compute Environment"
date: 2022-07-22T15:58:58Z
weight : 50
tags : ["configuration", "vpc", "subnet", "iam", "pem"]
---

In this step,
- Create AWS Batch Compute Environment and Job Queue using aws cli

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
    "maxvCpus": 384,
    "desiredvCpus": 0,
    "launchTemplate": {
      "launchTemplateId": "LAUNCH_TEMPLATE",
      "version": "1"
    },
    "instanceTypes": [
      "dl1.24xlarge"
    ],
    "subnets": [
      "SUBNET"
    ],
    "ec2KeyPair": "PEM_KEY_NAME",
    "instanceRole": "INSTANCE_ROLE",
    "tags": {
      "Name": "dl1_mnp_ce"
    }
  },
  "serviceRole": "BATCH_SERVICE_ROLE"
}

```

{{% notice info %}}
**Note: When you are entering strings inside JSON file, it has to be quoted for a valid json**
{{% /notice %}}

| PlaceHolder      	| Replace With                                                           	|
|------------------	|------------------------------------------------------------------------	|
| INSTANCE_ROLE 	| arn:aws:iam::xxxxxxxx:instance-profile/ecsInstanceRole 	|
| LAUNCH_TEMPLATE  	| lt-xxxxxxxx                                             	|
| SUBNET           	| subnet-xxxxxxxx                                         	|
| PEM_KEY_NAME     	| key_name w/o .pem extension                                          	|
| BATCH_SERVICE_ROLE| arn:aws:iam::xxxxxxxxxxx:role/service-role/AWSBatchServiceRole                                          	|

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