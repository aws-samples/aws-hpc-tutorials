+++
title = "b. Create your AWS Batch Architecture"
date = 2019-09-18T10:46:30-04:00
weight = 30
tags = ["tutorial", "install", "AWS", "batch", "Docker"]
+++


In the previous step, you successfully deployed the VPC template. In this step we will deploy your AWS Batch environment within the VPC. 

Both templates can be found in the repository of the [monitoring solution](https://github.com/aws-samples/aws-batch-runtime-monitoring) or directly [here](https://raw.githubusercontent.com/aws-samples/aws-batch-runtime-monitoring/main/docs/ExamplesCfnTemplates/VPC-Large-Scale.yaml) for the VPC stack and [here](https://raw.githubusercontent.com/aws-samples/aws-batch-runtime-monitoring/main/docs/ExamplesCfnTemplates/Batch-Large-Scale.yaml) the AWS Batch stack. 

We are going to go through how to deploy the AWS Batch CloudFormation template both through the console and by using the AWS CLI. 

#### To deploy the Batch CloudFormation stack (console)
1. Download the [Batch CloudFormation Template](https://raw.githubusercontent.com/aws-samples/aws-batch-runtime-monitoring/main/docs/ExamplesCfnTemplates/Batch-Large-Scale.yaml)
2. Open the AWS Cloudformation console ([link](https://console.aws.amazon.com/cloudformation/)).
3. For **Create Stack**, choose **With new resources**. ![CloudFormation Create Stack](/images/aws-batch/deep-dive/CloudFormation_2.png)
4. In the *Create stack* section, do the following:
    

    a. Choose **Template is ready**. 

    b. Choose **Upload a template file**.  

    c. Choose the AWS Batch CloudFormation template you downloaded in step 1. 

    d. Choose **Next**. ![CloudFormation Prep Template](/images/aws-batch/deep-dive/CloudFormation_-_Stack-12.png)

5. In the Specify stack details section, do the following:

    a. For **Stack Name**, enter `LargeScaleBatch`.

    b. Leave the **Parameters** settings with their default values.

    c. Choose **Next**. ![CloudFormation Prep Template](/images/aws-batch/deep-dive/CloudFormation_-_Stack-16.png)

6. Leave all the fields in the **Configure stack options** at the default values. Choose **Next**. 

7. In the *Review* section, do the following:
    
    a. Review the stack details. ![CloudFormation Prep Template](/images/aws-batch/deep-dive/CloudFormation_-_Stack-17.png)

    b. Select to **acknowledge that the AWS CloudFormation might create IAM resources**. 

    c. Choose **Create stack**. ![CloudFormation Prep Template](/images/aws-batch/deep-dive/CloudFormation_-_Stack-9.png)

 
The stack will now be created and all the resources in the template will be deployed. Wait until you see `CREATE_COMPLETE` before you deploy the stack in the next step. The deployment should only take a few minutes.
![CloudFormation success](/images/aws-batch/deep-dive/CloudFormation_-_Stack-18.png)

We have now deployed the AWS Batch CloudFormation template using the Amazon Console. Below are the instructions if you would like to deploy using the AWS Cli.

#### To deploy the Batch CloudFormation stack (AWS CLI) 
1. Note the stack name of your VPC stack created in the previous step. To deploy the AWS Batch CloudFormation stack you must provide the name of your VPC Stack as a parameter.
2. Copy the code block below.
3. Modify for the VPC stack name

```bash
#!/bin/bash
aws cloudformation create-stack --stack-name BatchStack \
  --template-body file://1.BatchLargeScale.yaml \
  --parameters ParameterKey=VPCStackParameter,ParameterValue=LargeScaleVPC \
  --capabilities CAPABILITY_NAMED_IAM
```
4. Submit the code block.

The stack will now be created and all the resources in the template will be deployed. Wait until you see `CREATE_COMPLETE` before you deploy the stack in the next step. The deployment should only take a few minutes.

#### Next Steps
At this point you have successfully deployed both your *Large Scale VPC stack* and *Large Scale Batch Environment*. 
[This](https://raw.githubusercontent.com/aws-samples/aws-batch-runtime-monitoring/main/docs/ExamplesCfnTemplates/Batch-Large-Scale.yaml) stack configures:
- Your Batch Compute Environments, Job Queues, and the Job Definition for the tests.
- Your CEs in every private subnet of your VPC. The CE uses the [*Spot Capacity Optimized*](https://docs.aws.amazon.com/batch/latest/userguide/allocation-strategies.html) allocation strategy and is set to scale between 0 to 100,000 vCPUs. The deployed CE is configured to pick instances from the m5, m4, c5 and c4 families. 
- An Amazon Elastic Container Registry (ECR) is created to store your container image, it is already referenced to in the Job Definition.

In the next section you will build and upload your container.

#### Quick Overview of Spot Instances

Many customers use [Amazon EC2 Spot Instances](https://aws.amazon.com/ec2/spot/) to save on their compute cost. [Amazon EC2 Spot Instances](https://aws.amazon.com/ec2/spot/) offer spare compute capacity available in the AWS cloud at steep discounts compared to On-Demand instances. Spot Instances enable you to optimize your costs on the AWS cloud and scale your application's throughput up to 10X for the same budget.

Spot Instances can be interrupted by EC2 with two minutes of notification when EC2 needs the capacity back. You can use Spot Instances for various fault-tolerant and flexible applications, such as big data, containerized workloads, high-performance computing (HPC), stateless web servers, rendering, CI/CD and other test & development workloads.


