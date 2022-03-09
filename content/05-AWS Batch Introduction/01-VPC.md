+++
title = "b. Deploy VPC and Batch Environments"
date = 2019-09-18T10:46:30-04:00
weight = 20
tags = ["tutorial", "install", "AWS", "Batch"]
+++

Before deploying your AWS Batch environment you will need to setup your network architecture.

### Create IAM role with Administrator Access

Deploy the two CloudFormation templates to create a new VPC. Both templates can be found in the repository of the monitoring solution or directly here for the VPC stack and here to deploy your AWS Batch environment. Once your retrieved and located the stacks, proceed to the steps below:


Deploy the VPC CloudFormation stack: you will need to select the Availability Zones (AZs) to deploy your subnets. You can use the AWS Console or the AWS CLI as shown below (change the us-east-1 region and the AZs to your preferred settings).
- Selecting all AZs in your region taps into all available instances’ pools.
- The stack also deploys an Amazon S3 endpoint and Amazon DynamoDB endpoint.

```bash
#!/bin/bash
aws cloudformation create-stack --stack-name LargeScaleVPC \
  --template-body file://0.VPC-Large-Scale.yaml \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameters \
        ParameterKey=AvailabilityZones,ParameterValue=us-east-1a\\,us-east-1b\\,us-east-1c\\,us-east-1d\\,us-east-1e\\,us-east-1f \
        ParameterKey=NumberOfAZs,ParameterValue=6

```
