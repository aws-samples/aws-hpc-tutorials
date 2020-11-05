+++
title = "g. Attach an IAM Role to Lambda"
date = 2019-09-18T10:46:30-04:00
weight = 180
tags = ["tutorial", "serverless", "ParallelCluster", "Lambda", "Slurm"]
+++

{{% notice info %}}
The IAM changes you are conducting here with the AWS CLI can also be done using AWS CloudFormation like in [*section b*](/04-serverless/02-serverless-iam/02-iam-policy2.html) or with the [AWS Console](https://aws.amazon.com/console/). There are always multiple options for you to interest with services in the cloud. Feel free to explore them.
{{% /notice %}}

{{% notice warning %}}
Remember the bucket you created in [**section b**](/04-serverless/02-serverless-iam/02-iam-policy1.html)? you will need its name for the following steps.
{{% /notice %}}

{{% notice warning %}}
You will also need the name of the default execution role created by AWS Lambda in [**section f**](/04-serverless/06-slurm-lambda-config/06-config2.html)
{{% /notice %}}


By default, AWS Lambda create an execution role with permissions to upload logs to [Amazon CloudWatch](https://aws.amazon.com/cloudwatch/) Logs. You can customize this default role later when adding triggers. In this case you will add an additional Policy to this role for the Lambda function to execute the scheduler (Slurm) commands using AWS Systems Manager (SSM).
