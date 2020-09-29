+++
title = "d. Execute the Lambda Function with API Gateway"
date = 2019-09-18T10:46:30-04:00
weight = 200 
tags = ["tutorial", "serverless", "ParallelCluster", "Lambda", "Slurm", "API Gateway"]
+++


The [Amazon API Gateway](https://aws.amazon.com/api-gateway/) allows the creation of REST and WebSocket APIs that act as a front door for applications to access data, business logic or functionality from your backend services like [AWS Lambda](https://aws.amazon.com/lambda/)

In this section, we will execute the the AWS Lambda function created in the previous section with a REST API created using Amazon API Gateway. The REST API refers to a collection of resources and methods that can be invoked through HTTPS endpoints

1. Open the AWS Management Console and go to Services -> API Gateway

2. Choose an API type, scroll down to **REST API** and click on Build
   ![Choose API](/images/serverless/api-gateway-1.png)

3. Create new API, click on New API. For API name, say **slurmAPI**. You can leave the Description field blank or provide a short description for your API. Select **Regional** for **Endpoint Type** and then click on **Create API**
   ![Choose API](/images/serverless/api-gateway-2.png)

4. You will now create the **slurm** resource by choosing the root resource (/) in the Resources tree and selecting **Create Resource** from the Actions dropdown menu as shown
   ![API Resource](/images/serverless/api-gateway-3.png)

5. Configure the New Child Resource as follows and select **Create Resource**

   **Configure as proxy resource**: unchecked

   **Resource Name**: slurm

   **Resource Path**: /slurm

   **Enable API Gateway CORS**: unchecked

   ![API Resource](/images/serverless/api-gateway-4.png)

6. In the Resource list, choose **/slurm** and then select **Create Method** from the **Actions** dropdown menu as shown 
   ![API Resource](/images/serverless/api-gateway-5.png)

7. Choose **ANY** from the dropdown menu and click on the checkmark icon as shown. This is basically setting the **ANY** method for HTTP which allows you to use a single API method setup for all the supported HTTP methods
   ![API Resource](/images/serverless/api-gateway-6.png)

8. In the **/slurm - ANY - Setup** section choose the following settings and click **Save**

   **Integration type**: Lambda Function

   **Use Lambda Proxy integration**: checked

   **Lambda Region**: us-east-1 (or select your appropriate region)

   **Lambda Function**: slurmAPI (Provide the Lambda function name you created in the previous section)

   **Use Default Timeout**: checked

   ![API Resource](/images/serverless/api-gateway-7.png)

   You will see a message saying, **You are about to give API Gateway permission to invoke your Lambda function**, click **OK**

9. You can now deploy the API by choosing **Deploy API** from the Actions dropdown menu as shown:
   ![API Resource](/images/serverless/api-gateway-8.png)

10. For **Deployment stage** choose **[New Stage]**, for **Stage name** enter **slurm** and then choose **Deploy**

    ![API Resource](/images/serverless/api-gateway-9.png)

11. Take note of the API's Invoke URL, it is required for the APIs interaction. 

    Example URL
    ![API Resource](/images/serverless/api-gateway-10.png)


You have successfully created the Slurm API which will execute the Slurm Lamda function. Next, you will interact with your cluster using this Slurm API. 


{{% notice tip %}}
To learn more about REST APIs in API Gateway see [here](https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-rest-api.html)
{{% /notice %}}

