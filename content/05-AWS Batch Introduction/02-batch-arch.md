+++
title = "c. Create your AWS Batch Architecture"
date = 2019-09-18T10:46:30-04:00
weight = 30
tags = ["tutorial", "install", "AWS", "batch", "Docker"]
+++


To deploy the AWS Batch CloudFormation stack you must provide the name of your VPC Stack as a parameter. The AWS Console or the AWS CLI (command below) can be used to deploy your stack.
- This stack configures your Batch Compute Environments, Job Queues, and the Job Definition for the tests. Your new VPC private subnets are used to configure your Batch Compute Environments.
- An Amazon Elastic Container Registry (ECR) is created to store your container image, it is already referenced to in the Job Definition.

```bash
#!/bin/bash
aws cloudformation create-stack --stack-name BatchStack \
  --template-body file://1.BatchLargeScale.yaml \
  --parameters ParameterKey=VPCStackParameter,ParameterValue=LargeScaleVPC \
  --capabilities CAPABILITY_NAMED_IAM
```

This stack deploys your CEs in every private subnet of your VPC. The CE uses the Spot Capacity Optimized allocation strategy and is set to scale between 0 to 100,000 vCPUs. If your Amazon EC2 service limits are lower than that number you can reduce the maxvCPUs for each CE in the Batch CloudFormation stack but it is not a requirement. The deployed CE is configured to pick instances from the m5, m4, c5 and c4 families.
