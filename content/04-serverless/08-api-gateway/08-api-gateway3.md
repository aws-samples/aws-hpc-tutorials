+++
title = "- Deploy your new API"
date = 2019-09-18T10:46:30-04:00
weight = 205
tags = ["tutorial", "serverless", "ParallelCluster", "Lambda", "Slurm", "API Gateway"]
+++

The steps to deploy your API are relatively straightforward.

1. Click on the **Actions** dropdown menu, and select **Deploy API**.
![API Resource](/images/serverless/api-gateway-8.png)
2. On the hovering window, on **Deployment stage** select **[New Stage]**, then for **Stage name** use `production` and, click **Deploy**.
![API Resource](/images/serverless/api-gateway-9.png)
3. Now your API is deployed! Please take note of the API's **Invoke URL**. You will be using this URL to interact with your API.
![API Resource](/images/serverless/api-gateway-10.png)


You have successfully created the API that will be calling your Lamda function to run Slurm commands on the head-node. Next, you will interact with your cluster using this new API.


{{% notice tip %}}
To learn more about REST APIs in API Gateway see [here](https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-rest-api.html)
{{% /notice %}}
