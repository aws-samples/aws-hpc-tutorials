+++
title = "c. Create your AWS Batch Architecture"
date = 2019-09-18T10:46:30-04:00
weight = 30
tags = ["tutorial", "install", "AWS", "batch", "Docker"]
+++

Now that your network architecture is set up, you will build your AWS Batch environment.

#### Deploy your AWS Batch Environment

To deploy the AWS Batch CloudFormation stack you must provide the name of your VPC Stack from the previous step as a parameter. The AWS Console or the AWS CLI (command below) can be used to deploy your stack.
- [This](https://raw.githubusercontent.com/aws-samples/aws-batch-runtime-monitoring/main/docs/ExamplesCfnTemplates/Batch-Large-Scale.yaml) stack configures your Batch Compute Environments, Job Queues, and the Job Definition for the tests. Your new VPC private subnets are used to configure your Batch Compute Environments.
- An Amazon Elastic Container Registry (ECR) is created to store your container image, it is already referenced to in the Job Definition.

```bash
#!/bin/bash
aws cloudformation create-stack --stack-name BatchStack \
  --template-body file://1.BatchLargeScale.yaml \
  --parameters ParameterKey=VPCStackParameter,ParameterValue=LargeScaleVPC \
  --capabilities CAPABILITY_NAMED_IAM
```

This stack deploys your CEs in every private subnet of your VPC. The CE uses the [*Spot Capacity Optimized*](https://docs.aws.amazon.com/batch/latest/userguide/allocation-strategies.html) allocation strategy and is set to scale between 0 to 100,000 vCPUs. If your [Amazon EC2 service limits](https://console.aws.amazon.com/servicequotas/home/services/ec2/quotas) are lower than that number you can reduce the maxvCPUs for each CE in the Batch CloudFormation stack but it is not a requirement. The deployed CE is configured to pick instances from the m5, m4, c5 and c4 families.

##### Overview of Spot Instances

Many customers use [Amazon EC2 Spot Instances](https://aws.amazon.com/ec2/spot/) to save on their compute cost. [Amazon EC2 Spot Instances](https://aws.amazon.com/ec2/spot/) offer spare compute capacity available in the AWS cloud at steep discounts compared to On-Demand instances. Spot Instances enable you to optimize your costs on the AWS cloud and scale your application's throughput up to 10X for the same budget.

Spot Instances can be interrupted by EC2 with two minutes of notification when EC2 needs the capacity back. You can use Spot Instances for various fault-tolerant and flexible applications, such as big data, containerized workloads, high-performance computing (HPC), stateless web servers, rendering, CI/CD and other test & development workloads.