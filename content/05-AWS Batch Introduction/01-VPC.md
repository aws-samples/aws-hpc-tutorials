+++
title = "b. Deploy VPC Environment"
date = 2019-09-18T10:46:30-04:00
weight = 20
tags = ["tutorial", "install", "AWS", "Batch"]
+++


#### Creating your VPC Environment

You will need to deploy two CloudFormation templates to build the environment. The first will create a new VPC and network environment; the second will will build your AWS Batch environment within the VPC. In this step we will focus on setting up your network architecture.

Both templates can be found in the repository of the [monitoring solution](https://github.com/aws-samples/aws-batch-runtime-monitoring) or directly [here](https://raw.githubusercontent.com/aws-samples/aws-batch-runtime-monitoring/main/docs/ExamplesCfnTemplates/VPC-Large-Scale.yaml) for the VPC stack and [here](https://raw.githubusercontent.com/aws-samples/aws-batch-runtime-monitoring/main/docs/ExamplesCfnTemplates/Batch-Large-Scale.yaml) to deploy your AWS Batch environment. We are going to go through how to deploy the cloudformation both through the console and by using the CLI.

##### Deploy the VPC CloudFormation stack via the Amazon Console
1. **Download** the [VPC CloudFormation Template](https://raw.githubusercontent.com/aws-samples/aws-batch-runtime-monitoring/main/docs/ExamplesCfnTemplates/VPC-Large-Scale.yaml)
2. **Open** the AWS Cloudformation console ([link](https://console.aws.amazon.com/cloudformation/)) to find your AWS CloudFormation stacks.
3. **Click** on Create Stack in the upper right hand corner. ![CloudFormation Create Stack](/images/aws-batch/deep-dive/CloudFormation_1.png)
4. **Select** the *With new resources* option ![CloudFormation Create Stack](/images/aws-batch/deep-dive/CloudFormation_2.png)
5. In the Prepare template section, **Select** *Template is ready* ![CloudFormation Prep Template](/images/aws-batch/deep-dive/CloudFormation_prepT_1.png)
6. In the Specify template section, **Select** *Upload a template file*.  Then **click** on the choose file putton and **choose** the VPC cloudformation template you downloaded in step 1 ![CloudFormation Prep Template](/images/aws-batch/deep-dive/CloudFormation_prepT_2.png)
7. **Type** a Stack Name. Here you can see the stack name is *LargeScaleVPC*. please use whatever you see fit. ![CloudFormation Prep Template](/images/aws-batch/deep-dive/CloudFormation_stackName.png)
8. **Type** the Name of your VPC. Here you can see the VPC name is *LargeScaleVPC*. please use whatever you see fit. ![CloudFormation Prep Template](/images/aws-batch/deep-dive/CloudFormation_-_Stack.png)
9. **Select** the Availability Zones (AZs) where you would like to deploy the VPC. Best practice is to select all Availability Zones within your Region of choice to tap into all available instances’ pools. **Type** the number of Availability Zones you selected. In this example we are using the us-east-1 Region. ![CloudFormation Prep Template](/images/aws-batch/deep-dive/CloudFormation_-_Stack-2.png)
10. **Leave** the *Network and Endpoint Configuration* settings with their default values. ![CloudFormation Prep Template](/images/aws-batch/deep-dive/CloudFormation_-_Stack-3.png)
11. **Select** the Availability Zone where the public subnet should be deployed. ![CloudFormation Prep Template](/images/aws-batch/deep-dive/CloudFormation_-_Stack-4.png)
12. **Click** on the *Next* button to proceed. ![CloudFormation Prep Template](/images/aws-batch/deep-dive/CloudFormation_-_Stack-6.png)
13. **Leave** all the fields at the *Configure stack options* at the default values.  ![CloudFormation Prep Template](/images/aws-batch/deep-dive/CloudFormation_-_Stack-5.png)
14. **Click** on the *Next* button to proceed. ![CloudFormation Prep Template](/images/aws-batch/deep-dive/CloudFormation_-_Stack-7.png)
15. **Review** the stack. ![CloudFormation Prep Template](/images/aws-batch/deep-dive/CloudFormation_-_Stack-8.png)
16. **Check** the confirmation box to acknowledge that the AWS CloudFormation might creatIAM resources. **Click** the *Create stack* button at the bottom of the page. ![CloudFormation Prep Template](/images/aws-batch/deep-dive/CloudFormation_-_Stack-9.png)
17. The stack will now be created and all the resources in the template will be deployed.![CloudFormation deploy](/images/aws-batch/deep-dive/CloudFormation_-_Stack_LargeScaleVPC.png)
18. **Wait** until you see *CREATE_COMPLETE* before you deploy the stack in the next step. The deployment should only take a few minutes.
![CloudFormation success](/images/aws-batch/deep-dive/CloudFormation_-_Stack-10.png)

We have now deployed the VPC CloudFormation template using the Amazon Console. Below are the instructions if you would like to deploy using the AWS Cli.

##### Deploy the VPC CloudFormation stack via the AWS CLI 

1. **Choose** the Availability Zones (AZs) where you would like to deploy your subnets. In the code block below we use us-east-1, **Change** the `us-east-1` region and the AZs to your preferred settings. Best practice is to select all Availability Zones within your Region of choice to tap into all available instances’ pools.
2. **Copy** the code block below and **Modify** for the desired region.

```bash
#!/bin/bash
aws cloudformation create-stack --stack-name LargeScaleVPC \
  --template-body file://0.VPC-Large-Scale.yaml \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameters \
        ParameterKey=AvailabilityZones,ParameterValue=us-east-1a\\,us-east-1b\\,us-east-1c\\,us-east-1d\\,us-east-1e\\,us-east-1f \
        ParameterKey=NumberOfAZs,ParameterValue=6

```
3. **Submit** the command

#### Next Steps
At this point you have successfully deployed your *Large Scale VPC stack*. This template sets up the VPC accross all the AZs with both public and private subnets. This stack also deploys an Amazon S3 endpoint and Amazon DynamoDB endpoint.

In the next section you will deploy the Batch Template.
