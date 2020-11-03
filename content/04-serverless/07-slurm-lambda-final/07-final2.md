+++
title = "- Add the lambda IAM policy"
date = 2019-09-18T10:46:30-04:00
weight = 185
tags = ["tutorial", "IAM", "ParallelCluster", "Serverless"]
+++

You will now add a new policy by adding in the JSON format. You could use the visual editor as well but let's  stick with JSON for now. Before you begin you will need to have the ID of the current AWS region and the name of the bucket previously created. If you don't remember those you can run the commands below in your AWS Cloud9 terminal.

1. Retrieve the current AWS region ID:

    ```bash
    aws configure get region
    ```

2. List your Amazon S3 buckets and pick the one you just created:

    ```bash
    aws s3 list-buckets --query "Buckets[].Name"
    ```

3. Paste the policy below in the JSON editor and do not forget to replace **\<REGION\>** and **\<YOUR-S3-BUCKET-NAME\>** with the values you retrieved earlier. This policy enables your Lambda function to access AWS Systems Manager (SSM).


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
5. You will be asked to provide a **Name** to your policy, pick the one you like such as (e.g. `lambda-slurm-exec`) and click on **Create policy**. This will validate the policy then redirect your to the *Policies* page, close this tab for now.
![Lambda IAM ](/images/serverless/lambda-iamrole5.png)
