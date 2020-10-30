+++
title = "- Attach the IAM policy to the role"
date = 2019-09-18T10:46:30-04:00
weight = 187
tags = ["tutorial", "IAM", "ParallelCluster", "Serverless"]
+++
Now you will attach the policy you have created to the role that your Lambda function assumes.

1. First go to your web-browser tab with **Add permissions to SlurmFrontEnd-role-*randomstring***. This is the one you used to start creating the policy.

2. **Click on** the refresh button with **two arrows** (1 in the image) to refresh the policies list. Search for the name of the policy you just created (2 in the image), then select it and click **Attach policy** a

![Lambda IAM ](/images/serverless/lambda-iamrole6.png)

You are done with IAM and Lambda. Do note hesitate to explore the services you discovered beyond this tutorial. Next, you will attach your AWS Lambda function to Amazon API Gateway.

{{% notice note %}}
As an exercise you can trying creating the above AWS Lambda function using AWS Cloudformation.
{{% /notice %}}
