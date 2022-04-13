+++
title = "c. Create your AWS Batch Architecture"
date = 2019-09-18T10:46:30-04:00
weight = 30
tags = ["tutorial", "install", "AWS", "batch", "Docker"]
+++

#### Creating your Batch Environment

In the previous step you successfully deployed the VPC template. The second template will build your AWS Batch environment within the VPC. In this step, you will focus on setting up your Batch architecture.

Both templates can be found in the repository of the [monitoring solution](https://github.com/aws-samples/aws-batch-runtime-monitoring) or directly [here](https://raw.githubusercontent.com/aws-samples/aws-batch-runtime-monitoring/main/docs/ExamplesCfnTemplates/Batch-Large-Scale.yaml) to deploy your AWS Batch environment. We are going to go through how to deploy the cloudformation both through the console and by using the CLI.


##### Deploy the Batch CloudFormation stack via the Amazon Console
1. **Download** the [Batch CloudFormation Template](https://raw.githubusercontent.com/aws-samples/aws-batch-runtime-monitoring/main/docs/ExamplesCfnTemplates/Batch-Large-Scale.yaml)
2. **Open** the AWS Cloudformation console ([link](https://console.aws.amazon.com/cloudformation/)) to find your AWS CloudFormation stacks.
3. **Click** on Create Stack in the upper right hand corner. ![CloudFormation Create Stack](/images/aws-batch/deep-dive/CloudFormation_1.png)
4. **Select** the *With new resources* option ![CloudFormation Create Stack](/images/aws-batch/deep-dive/CloudFormation_2.png)
5. In the Prepare template section, **Select** *Template is ready* ![CloudFormation Prep Template](/images/aws-batch/deep-dive/CloudFormation_-_Stack-11.png)
6. In the Specify template section, **Select** *Upload a template file*.  Then **click** on the choose file putton and **choose** the VPC cloudformation template you downloaded in step 1 ![CloudFormation Prep Template](/images/aws-batch/deep-dive/CloudFormation_-_Stack-12.png)
7. **Type** the Name of your VPC. Here you can see the VPC name is *LargeScaleVPC*. please use whatever you see fit. ![CloudFormation Prep Template](/images/aws-batch/deep-dive/CloudFormation_-_Stack-13.png)
8. **Leave** the *Parameters* settings with their default values. ![CloudFormation Prep Template](/images/aws-batch/deep-dive/CloudFormation_-_Stack-14.png)
9. **Click** on the *Next* button to proceed. ![CloudFormation Prep Template](/images/aws-batch/deep-dive/CloudFormation_-_Stack-16.png)
10. **Leave** all the fields in the *Configure stack options* at the default values.  ![CloudFormation Prep Template](/images/aws-batch/deep-dive/CloudFormation_-_Stack-15.png)
11. **Click** on the *Next* button to proceed. ![CloudFormation Prep Template](/images/aws-batch/deep-dive/Cursor_and_CloudFormation_-_Stack.png)
12. **Review** the stack. ![CloudFormation Prep Template](/images/aws-batch/deep-dive/CloudFormation_-_Stack-17.png)
13. **Check** the confirmation box to acknowledge that the AWS CloudFormation might creatIAM resources. **Click** the *Create stack* button at the bottom of the page. ![CloudFormation Prep Template](/images/aws-batch/deep-dive/CloudFormation_-_Stack-9.png)
14. The stack will now be created and all the resources in the template will be deployed.![CloudFormation deploy](/images/aws-batch/deep-dive/CloudFormation_-_Stack_LargeScaleBatch.png)
15. The deployment should only take a few minutes. You can **proceed** to the next step while the stack finishes building.  
![CloudFormation success](/images/aws-batch/deep-dive/CloudFormation_-_Stack-18.png)

##### Deploy the Batch CloudFormation stack via the AWS CLI 
1. **Note** the stack name of your VPC stack. To deploy the AWS Batch CloudFormation stack you must provide the name of your VPC Stack from the previous step as a parameter.
2. **Copy** the code block below and **Modify** for the VPC stack name

```bash
#!/bin/bash
aws cloudformation create-stack --stack-name BatchStack \
  --template-body file://1.BatchLargeScale.yaml \
  --parameters ParameterKey=VPCStackParameter,ParameterValue=LargeScaleVPC \
  --capabilities CAPABILITY_NAMED_IAM
```
3. **Submit** the command and **Note** a successful deployment.

#### Next Steps
At this point you have successfully deployed both your *Large Scale VPC stack* and *Large Scale Batch Environment*. 
[This](https://raw.githubusercontent.com/aws-samples/aws-batch-runtime-monitoring/main/docs/ExamplesCfnTemplates/Batch-Large-Scale.yaml) stack configures:
- Your Batch Compute Environments, Job Queues, and the Job Definition for the tests.
- Your CEs in every private subnet of your VPC. The CE uses the [*Spot Capacity Optimized*](https://docs.aws.amazon.com/batch/latest/userguide/allocation-strategies.html) allocation strategy and is set to scale between 0 to 100,000 vCPUs. The deployed CE is configured to pick instances from the m5, m4, c5 and c4 families. 
- An Amazon Elastic Container Registry (ECR) is created to store your container image, it is already referenced to in the Job Definition.


##### Quick Overview of Spot Instances

Many customers use [Amazon EC2 Spot Instances](https://aws.amazon.com/ec2/spot/) to save on their compute cost. [Amazon EC2 Spot Instances](https://aws.amazon.com/ec2/spot/) offer spare compute capacity available in the AWS cloud at steep discounts compared to On-Demand instances. Spot Instances enable you to optimize your costs on the AWS cloud and scale your application's throughput up to 10X for the same budget.

Spot Instances can be interrupted by EC2 with two minutes of notification when EC2 needs the capacity back. You can use Spot Instances for various fault-tolerant and flexible applications, such as big data, containerized workloads, high-performance computing (HPC), stateless web servers, rendering, CI/CD and other test & development workloads.

In the next section you will build and upload your container.