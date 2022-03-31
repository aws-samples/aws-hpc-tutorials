+++
title = "b. Deploy VPC Environment"
date = 2019-09-18T10:46:30-04:00
weight = 20
tags = ["tutorial", "install", "AWS", "Batch"]
+++

Before deploying your AWS Batch environment you will need to setup your network architecture.

### Creating your VPC Environment

You will deploy two CloudFormation templates to build the environment. The first will create a new VPC and network and the next will build your AWS Batch environment on within the VPC. Both templates can be found in the repository of the [monitoring solution](https://github.com/aws-samples/aws-batch-runtime-monitoring) or directly [here](https://raw.githubusercontent.com/aws-samples/aws-batch-runtime-monitoring/main/docs/ExamplesCfnTemplates/VPC-Large-Scale.yaml) for the VPC stack and [here](https://raw.githubusercontent.com/aws-samples/aws-batch-runtime-monitoring/main/docs/ExamplesCfnTemplates/Batch-Large-Scale.yaml) to deploy your AWS Batch environment. Once your retrieved and located the stacks, proceed to the steps below:


#### Deploy the VPC CloudFormation stack: 
You will need to select the Availability Zones (AZs) to deploy your subnets. You can use the AWS Console or the AWS CLI as shown below (change the `us-east-1` region and the AZs to your preferred settings).
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
