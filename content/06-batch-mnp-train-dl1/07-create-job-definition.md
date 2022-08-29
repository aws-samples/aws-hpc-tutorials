---
title : "g. Create AWS Batch Job Definition"
date: 2022-07-22T15:58:58Z
weight : 80
tags : ["configuration", "vpc", "subnet", "iam", "pem"]
---

In this section,
- create the AWS Batch Multi-Nodel Parallel job definition as a json file
- create the artifact using aws-cli

### Multi Node Job Definition Template

The template job definition is given below along with the placeholder values that needs to replaced based on your setup. Other values could be left at the defaults and the reason for the choice of the values are explained below:
- Instance being selected is a dl1.24xlarge (which has 768 GB of Memory, 8 HPU, 96 vCPU)
- Resource Requirements of 760GB and 96vCPU is made per node
- Shared Memory of 64GB is specified to be set for shmem usage across the containers
- Elevated previleges for the container is desired
- Default number of nodes is set as 2 (This can be changed at the time of launch)
- Each node properties is specified as range 0: (This automatically applies the same node properties to all nodes from 0 to numNodes-1)
- Two volumes are mounted
    - /mnt/efs (EFS Volume)
    - /scratch (Scratch Volume)

Copy and paste the template into **dl1_batch_jd.json** and replace the placeholder values.
```json
{
  "jobDefinitionName": "dl1_mnp_batch_jd",
  "type": "multinode",
  "nodeProperties": {
    "numNodes": 2,
    "mainNode": 0,
    "nodeRangeProperties": [
      {
        "targetNodes": "0:",
        "container": {
          "image": "IMAGE_NAME",
          "command": [],
          "executionRoleArn": "TASK_EXEC_ROLE",
          "resourceRequirements": [
            {
              "type": "MEMORY",
              "value": "760000"
            },
            {
              "type": "VCPU",
              "value": "96"
            }
          ],
          "mountPoints": [
            {
              "containerPath": "/scratch",
              "sourceVolume": "scratch"
            },
            {
                "containerPath": "/mnt/efs",
                "sourceVolume": "efs"
            }
          ],
          "volumes": [
              {
                  "host": {
                      "sourcePath": "/scratch"
                  },
                  "name": "scratch"
              },
              {
                  "host": {
                      "sourcePath": "/mnt/efs"
                  },
                  "name": "efs"
              }
          ],
          "environment": [
              {
                  "name": "SCRATCH_DIR",
                  "value": "/scratch"
              },
              {
                  "name": "JOB_DIR",
                  "value": "/mnt/efs"
              }
          ],
          "ulimits": [],
          "instanceType": "dl1.24xlarge",
          "linuxParameters": {
            "sharedMemorySize": 64000,
            "devices": [
              {
                "hostPath": "/dev/infiniband/uverbs0",
                "containerPath": "/dev/infiniband/uverbs0",
                "permissions": [
                    "READ", "WRITE", "MKNOD"
                ]
              }
            ]
          },
          "secrets": [
            {
              "name": "MPI_SSH_KEY",
              "valueFrom": "SECRETS_ARN"
            }
          ],
          "privileged": true
        }
      }
    ]
  }
}
```
{{% notice info %}}
**Note: When you are entering strings inside JSON file, it has to be quoted for a valid json**
{{% /notice %}}

| PlaceHolder      	| Replace With                                                           	|
|------------------	|------------------------------------------------------------------------	|
| IMAGE_NAME        | xxxxxxxxx.dkr.ecr.us-east-1.amazonaws.com/dl1_bert_train:v1|
| TASK_EXEC_ROLE 	| arn:aws:iam::xxxxxxx:role/ecsTaskExecutionRole 	|
| SECRETS_ARN 	| arn:aws:secretsmanager:us-east-1:xxxxxxx:secret:MPI_SSH_KEY-xxxxx 	|

### Create the Job Definition using aws cli

Use the aws cli to register the job definition

```bash
aws batch register-job-definition --cli-input-json file://dl1_batch_jd.json
```

You can use the AWS Batch Console to verify the
- Compute Environment
- Job Queue
- Job Definition

Next we launch a job from the job definition and test out distributed traning with multiple nodes