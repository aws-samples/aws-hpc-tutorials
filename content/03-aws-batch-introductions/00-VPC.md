+++
title = "a. Deploy VPC Environment"
date = 2019-09-18T10:46:30-04:00
weight = 20
tags = ["tutorial", "install", "AWS", "Batch"]
+++


To begin this workshop, you will need to deploy two CloudFormation templates to build the necessary environments. The first will create a new VPC and network environment; the second will build your AWS Batch environment within the VPC. 

In this section, you will build the required VPC and network architecture.

Both templates can be found in the repository of the [monitoring solution](https://github.com/aws-samples/aws-batch-runtime-monitoring) or directly [here](https://raw.githubusercontent.com/aws-samples/aws-batch-runtime-monitoring/main/docs/ExamplesCfnTemplates/VPC-Large-Scale.yaml) for the VPC stack and [here](https://raw.githubusercontent.com/aws-samples/aws-batch-runtime-monitoring/main/docs/ExamplesCfnTemplates/Batch-Large-Scale.yaml) the AWS Batch stack. 

We are going to go through how to deploy the VPC CloudFormation template both through the console and by using the AWS CLI. To learn more about Amazon VPC see [here](https://docs.amazonaws.cn/en_us/vpc/latest/userguide/what-is-amazon-vpc.html) 

#### To deploy the VPC CloudFormation stack (console)
1. Download the [VPC CloudFormation Template.](https://raw.githubusercontent.com/aws-samples/aws-batch-runtime-monitoring/main/docs/ExamplesCfnTemplates/VPC-Large-Scale.yaml)
2. Open the AWS Cloudformation console ([link](https://console.aws.amazon.com/cloudformation/)).
3. For **Create Stack**, choose **With new resources**. ![CloudFormation Create Stack](/images/aws-batch/deep-dive/CloudFormation_2.png)
4. In the *Create stack* section, do the following:

    a. Choose **Template is ready**. 

    b. Choose **Upload a template file**.  

    c. Choose the VPC CloudFormation template you downloaded in step 1. ![CloudFormation Prep Template](/images/aws-batch/deep-dive/CloudFormation_prepT_2.png)

    d. Choose **Next**.
5. In the *Specify stack details* section, do the following:

    a. For **Stack Name**, enter `LargeScaleVPC`.  ![CloudFormation Prep Template](/images/aws-batch/deep-dive/CloudFormation_stackName.png)

    b. For the **Name of your VPC**, enter `LargeScaleVPC`. 

    c. Choose the **Availability Zones (AZs)** where you would like to deploy the VPC. *Best practice is to select all Availability Zones within your Region of choice to tap into all available instances pools.* 

    d. For the **Number of Availability Zones**, enter the number of Availability Zones you selected in the previous step. In this example we are using the us-east-1 Region. 

    d. In the **Network and Endpoint Configuration** section, leave the default values. 

    e. Choose the **Availability Zone** where the public subnet will be deployed. 

    f. Choose **Next**. ![CloudFormation Prep Template](/images/aws-batch/deep-dive/CloudFormation_-_Stack-5.png)

6. In the *Configure stack options* section, leave the default values. Choose **Next**. 
7.  In the *Review* section, do the following:
    
    a. Review the stack details. ![CloudFormation Prep Template](/images/aws-batch/deep-dive/CloudFormation_-_Stack-8.png)

    b. Select to **acknowledge that the AWS CloudFormation might create IAM resources**. 

    c. Choose **Create stack**. ![CloudFormation Prep Template](/images/aws-batch/deep-dive/CloudFormation_-_Stack-9.png)

 
The stack will now be created and all the resources in the template will be deployed. Wait until you see `CREATE_COMPLETE` before you deploy the stack in the next step. The deployment should only take a few minutes.
![CloudFormation success](/images/aws-batch/deep-dive/CloudFormation_-_Stack-10.png)

We have now deployed the VPC CloudFormation template using the Amazon Console. Below are the instructions if you would like to deploy using the AWS Cli.

#### To deploy the VPC CloudFormation stack (AWS CLI)

1. Choose the **Availability Zones (AZs)** where you would like to deploy your subnets. *Best practice is to use all Availability Zones within your Region of choice to tap into all available instances’ pools.*
2. Copy the code block below.
3. Modify for the desired Region and Availability Zones.

```bash
#!/bin/bash
aws cloudformation create-stack --stack-name LargeScaleVPC \
  --template-body file://0.VPC-Large-Scale.yaml \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameters \
        ParameterKey=AvailabilityZones,ParameterValue=us-east-1a\\,us-east-1b\\,us-east-1c\\,us-east-1d\\,us-east-1e\\,us-east-1f \
        ParameterKey=NumberOfAZs,ParameterValue=6

```
4. Submit the code block.

The stack will now be created and all the resources in the template will be deployed. Wait until you see `CREATE_COMPLETE` before you deploy the stack in the next step. The deployment should only take a few minutes.

#### Next Steps
At this point you have successfully deployed your *Large Scale VPC stack*. This template sets up the VPC accross all the selected AZs with both public and private subnets. This stack also deploys an Amazon S3 endpoint and Amazon DynamoDB endpoint.

In the next section you will deploy the Batch Template.
