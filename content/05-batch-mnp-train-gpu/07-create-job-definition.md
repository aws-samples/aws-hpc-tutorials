---
title : "g. Create AWS Batch Job Definition"
date: 2022-07-22T15:58:58Z
weight : 80
tags : ["configuration", "vpc", "subnet", "iam", "pem"]
---

In this section you will create the AWS Batch Multi-Nodel Parallel job definition as a json and create the artifact using aws-cli

### Multi Node Job Definition Template

The template job definition is given below along with the placeholder values that needs to replaced based on your setup. Other values could be left at the defaults and the reason for the choice of the values are explained below:
- Instance being selected is a g5.2xlarge (which has 32 GB of Memory, 1 GPU, 8 vCPU)
- Resource Requirements of 16GB, 1GPU and 8vCPU is made per node
- Shared Memory of 8GB is specified to be set for shmem usage across the containers
- Elevated previleges for the container is desired
- Default number of nodes is set as 2 (This can be changed at the time of launch)
- Each node properties is specified as range 0: (This automatically applies the same node properties to all nodes from 0 to numNodes-1)
- Two volumes are mounted
    - /mnt/efs (EFS Volume)
    - /scratch (Scratch Volume)

Copy and paste the template into **gpu_batch_jd.json** and replace the placeholder values.
```json
{
  "jobDefinitionName": "gpu_mnp_batch_jd",
  "type": "multinode",
  "nodeProperties": {
    "numNodes": 2,
    "mainNode": 0,
    "nodeRangeProperties": [
      {
        "targetNodes": "0:",
        "container": {
          "image": IMAGE_NAME,
          "command": [],
          "jobRoleArn": TASK EXEC ROLE,
          "resourceRequirements": [
            {
              "type": "MEMORY",
              "value": "16000"
            },
            {
              "type": "VCPU",
              "value": "8"
            },
            {
              "type": "GPU",
              "value": "1"
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
          "instanceType": "g5.2xlarge",
          "linuxParameters": {
            "sharedMemorySize": 8000
          },
          "privileged": true
        }
      }
    ]
  }
}
```

| PlaceHolder      	| Replace With                                                           	|
|------------------	|------------------------------------------------------------------------	|
| IMAGE_NAME        | `"0123456789.dkr.ecr.us-east-1.amazonaws.com/g5_train:v1"`|
| TASK EXEC ROLE 	| `"arn:aws:iam::0123456789:role/ecsTaskExecutionRole"` 	|

### Create the Job Definition using aws cli

Use the aws cli to register the job definition

```bash
aws batch register-job-definition --cli-input-json file://gpu_batch_jd.json
```

You can use the AWS Batch Console to verify the
- Compute Environment
- Job Queue
- Job Definition

Next we will go through the process of launching a job from the job definition and test out distributed traning with multiple nodes