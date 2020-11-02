+++
title = "- Bind the REST API to your Lambda function"
date = 2019-09-18T10:46:30-04:00
weight = 203
tags = ["tutorial", "serverless", "ParallelCluster", "Lambda", "Slurm", "API Gateway"]
+++

You will first define to which [HTTP methods](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol#Request_methods) your REST API will respond. You can bind different methods to different Lambda functions or other services.

1. In the Resource list, choose **/slurm** if not already selected. Click on the **Actions** dropdown menu then select **Create Method**.
![API Resource](/images/serverless/api-gateway-5.png)
2. Select **ANY** from the dropdown menu and validate. This is basically setting the **ANY** method for HTTP which allows you to use a single API method setup for all the supported HTTP methods.
![API Resource](/images/serverless/api-gateway-6.png)
3. In the **/slurm - ANY - Setup** section tick the **Use Lambda Proxy integration**, select the region where your function resides (*us-east-1* in the screenshot, yours may differ). Then add the name of your lambda function in the **Lambda Function** field. Leave all other values to default and click **Save**.
![API Resource](/images/serverless/api-gateway-7.png)
4. You will see a message on an hovering  message, ignore it and click **OK**. You will be redirected to a workflow diagram showing how the API and your function will be interacting together. The last step ahead of you before using your API is to deploy it.
