+++
title = "h. Bind Lambda with API Gateway"
date = 2019-09-18T10:46:30-04:00
weight = 200
tags = ["tutorial", "serverless", "ParallelCluster", "Lambda", "Slurm", "API Gateway"]
+++

{{% notice info %}}
[Amazon API Gateway](https://aws.amazon.com/api-gateway/) allows the creation of [REST](https://en.wikipedia.org/wiki/Representational_state_transfer) and WebSocket APIs that act as a front-end for applications to access data, business logic or functionalities provided by backend services such as [AWS Lambda](https://aws.amazon.com/lambda/).
{{% /notice %}}


In this section, we will attach the AWS Lambda function created in the previous section with a [REST API](https://en.wikipedia.org/wiki/Representational_state_transfer) created using Amazon API Gateway. You will start by creating our API, then you will bind it to our lambda function. The last part of this section consists of deploying your API.

#### A. Create the API Gateway and the REST Resource

1. Start by opening the AWS Management Console. Click on  **Services**, then select **API Gateway** (use the search field if convenient).

2. Choose an API type, scroll down to **REST API** and click on Build. Do not choose the non-private **REST API** as you are building a public facing API here. Once on the next page click on **OK** to close the hovering window.

![Choose API](/images/serverless/api-gateway-1.png)

3. You will now create a new API, select the radio box **New API**. Enter the **API name** (e.g. `SlurmFrontEndAPI`). Ensure that the **Endpoint Type** is **Regional**. When you are done, click on **Create API**

![Choose API](/images/serverless/api-gateway-2.png)

4. Now that we have an API we need to define a resource (similar to an object in [OOP](https://en.wikipedia.org/wiki/Object-oriented_programming)). Click on the button **Action**. Then select **Create Resource** in the drop down menu.
![API Resource](/images/serverless/api-gateway-3.png)

5. In the field **Resource Name** add `slurm`, in the field **Resource Path** add `slurm` as well. Leave other settings as they are and click on the button **Create Resource**

![API Resource](/images/serverless/api-gateway-4.png)

You have defined our API Gateway and REST API. You will now link it to the Lambda function created earlier.

#### B. Bind the REST API to your Lambda function

We will fist define to which [HTTP methods](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol#Request_methods) our REST API will respond. You can bind different methods to different Lambda functions or other services.

1. In the Resource list, choose **/slurm** if not already selected. Click on the **Actions** dropdown menu then select u**Create Method**.

![API Resource](/images/serverless/api-gateway-5.png)

2. Select **ANY** from the dropdown menu and validate. This is basically setting the **ANY** method for HTTP which allows you to use a single API method setup for all the supported HTTP methods.

![API Resource](/images/serverless/api-gateway-6.png)

3. In the **/slurm - ANY - Setup** section tick the **Use Lambda Proxy integration**, select the region where your function resides (*us-east-1* in the screenshot, yours may differ). Then add the name of your lambda function in the **Lambda Function** field. Leave all other values to default and click **Save**.

![API Resource](/images/serverless/api-gateway-7.png)

4. You will see a message on an hovering  message, ignore it and click **OK**. You will be redirected to a workflow diagram showing how the API and your function will be interacting together. The last step ahead of you before using your API is to deploy it.

#### C. Deploy your new API

The steps to deploy your API are relatively straightforward.

1. Click once more on the **Actions** dropdown menu, and select **Deploy API**.
![API Resource](/images/serverless/api-gateway-8.png)

2. On the hovering window, on **Deployment stage** select **[New Stage]**, then for **Stage name** use `production` and, click **Deploy**.

![API Resource](/images/serverless/api-gateway-9.png)

11. Now your API is deployed! Please take note of the API's **Invoke URL**. You will be using this URL to interact with your API.

![API Resource](/images/serverless/api-gateway-10.png)


You have successfully created the API that will be calling your Lamda function to run Slurm commands on the head-node. Next, you will interact with your cluster using this new API.


{{% notice tip %}}
To learn more about REST APIs in API Gateway see [here](https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-rest-api.html)
{{% /notice %}}

