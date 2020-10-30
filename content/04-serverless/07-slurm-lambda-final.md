+++
title = "g. Attach an IAM Role to Lambda"
date = 2019-09-18T10:46:30-04:00
weight = 170
tags = ["tutorial", "serverless", "ParallelCluster", "Lambda", "Slurm"]
+++

{{% notice info %}}
The IAM changes we are conducting here with the AWS Console can also be using Cloudformation like in [*section b*](/04-serverless/02-iam-policy-serverless.html) or with the [AWS CLI](https://docs.aws.amazon.com/cli/latest/reference/iam/index.html). There are always multiple options for you to interest with services in the cloud. Feel free to explore them.
{{% /notice %}}

{{% notice warning %}}
Remember the bucket you crated in [**section b**](/04-serverless/02-iam-policy-serverless.html)? We will need its name for the following steps.
{{% /notice %}}

By default, AWS Lambda create an execution role with permissions to upload logs to [Amazon CloudWatch](https://aws.amazon.com/cloudwatch/) Logs. You can customize this default role later when adding triggers. In this case we will add an additional Policy to this role for the Lambda function to execute the scheduler (Slurm) commands using AWS Systems Manager (SSM).

#### Access the policy editor

In the freshly-opened IAM tab, you will see details on the [IAM role](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html) attached to your function. To this role you can attach [IAM policies](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html) which define what this role allows or forbids.

1. Start by accessing the policy editor by clicking on **Attach policies**.

![Lambda Role](/images/serverless/lambda-iamrole1.png)

2. Then click on **Create policy**. This will open a new tab in your Browser.

![Lambda IAM](/images/serverless/lambda-iamrole3.png)

3. In this new tab, choose **Create policy** and then **JSON**.

![Lambda Role](/images/serverless/lambda-iamrole3.png)

#### Write the new policy

We will now add a new policy by adding in the JSON format. You could use the visual editor as well but let's  stick with JSON for now. Before you begin you will need to have the ID of the current AWS region and the name of the bucket previously created. If you don't remember those you can run the commands below in your AWS Cloud9 terminal.

1. Retrieve the current AWS region ID:

    ```bash
    aws configure get region
    ```

2. List your Amazon S3 buckets and pick the one you just created:

    ```bash
    aws s3 list-buckets --query "Buckets[].Name"
    ```

3. Paste the policy below in the JSON editor and do not forget to replace **\<REGION\>** and **\<YOUR-S3-BUCKET-NAME\>** with the values you retrieved earlier. This policy enables you Lambda function to access the AWS Systems Manager (SSM).


    ```json
    {
        "Version": "2012-10-17",
        "Statement": [{
            "Effect": "Allow",
            "Action": ["ssm:SendCommand"],
            "Resource": [
              "arn:aws:ec2:<REGION>:*:instance/*",
              "arn:aws:ssm:<REGION>::document/AWS-RunShellScript",
              "arn:aws:s3:::<YOUR-S3-BUCKET-NAME>/ssm"]
        }, {
            "Effect": "Allow",
            "Action": ["ssm:GetCommandInvocation"],
            "Resource": ["arn:aws:ssm:<REGION>:*:*"]
        }, {
            "Effect": "Allow",
            "Action": ["s3:*"],
            "Resource": [
              "arn:aws:s3:::<YOUR-S3-BUCKET-NAME>",
              "arn:aws:s3:::<YOUR-S3-BUCKET-NAME>/*"]
        }]
    }

    ```

4. When you are done with your changes click **Review policy**.

![Lambda IAM ](/images/serverless/lambda-iamrole4.png)

5. You will be asked to provide a **Name** to your policy, pick the one you like such as (e.g. lambda-slurm-exec) and click on **Create policy**. This will validate the policy then redirect your to the *Policies* page, close this tab for now.
![Lambda IAM ](/images/serverless/lambda-iamrole5.png)

#### Attach the policy to your Lambda function role

Now you will attach the policy you have created to the role that your Lambda function assumes.

1. First go to your web-browser tab with **Add permissions to SlurmFrontEnd-role-*randomstring***. This is the one you used to start creating the policy.

2. **Click on** the refresh button with **two arrows** (1 in the image) to refresh the policies list. Search for the name of the policy you just created (2 in the image), then select it and click **Attach policy** a

![Lambda IAM ](/images/serverless/lambda-iamrole6.png)

You are done with IAM and Lambda. Do note hesitate to explore the services you discovered beyond this tutorial. Next, you will attach your AWS Lambda function to Amazon API Gateway.

{{% notice note %}}
As an exercise you can trying creating the above AWS Lambda function using AWS Cloudformation.
{{% /notice %}}


