+++
title = "- Create the API Gateway and REST Resource"
date = 2019-09-18T10:46:30-04:00
weight = 201
tags = ["tutorial", "serverless", "ParallelCluster", "Lambda", "Slurm", "API Gateway"]
+++

Now we will create our API Gateway and REST Resource:

1. Start by opening the AWS Management Console. Click on  **Services**, then select **API Gateway** (use the search field if convenient).

2. Choose an API type, scroll down to **REST API** and click on Build. Choose the non-private **REST API** as you are building a public facing API here. Once on the next page click on **OK** to close the hovering window.
![Choose API](/images/serverless/api-gateway-1.png)
3. You will now create a new API, select the radio box **New API**. Enter the **API name** (e.g. `SlurmFrontEndAPI`). Ensure that the **Endpoint Type** is **Regional**. When you are done, click on **Create API**
![Choose API](/images/serverless/api-gateway-2.png)
4. Now that we have an API we need to define a resource (similar to an object in [OOP](https://en.wikipedia.org/wiki/Object-oriented_programming)). Click on the button **Action**. Then select **Create Resource** in the drop down menu.
![API Resource](/images/serverless/api-gateway-3.png)
5. In the field **Resource Name** add `slurm`, in the field **Resource Path** add `slurm` as well. Leave other settings as they are and click on the button **Create Resource**
![API Resource](/images/serverless/api-gateway-4.png)

You have defined our API Gateway and REST API. You will now link it to the Lambda function created earlier.
