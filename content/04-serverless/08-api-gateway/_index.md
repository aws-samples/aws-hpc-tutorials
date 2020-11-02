+++
title = "h. Bind Lambda with API Gateway"
date = 2019-09-18T10:46:30-04:00
weight = 200
tags = ["tutorial", "serverless", "ParallelCluster", "Lambda", "Slurm", "API Gateway"]
+++

{{% notice info %}}
[Amazon API Gateway](https://aws.amazon.com/api-gateway/) allows the creation of [REST](https://en.wikipedia.org/wiki/Representational_state_transfer) and WebSocket APIs that act as a front-end for applications to access data, business logic or functionalities provided by backend services such as [AWS Lambda](https://aws.amazon.com/lambda/).
{{% /notice %}}

In this section, you will attach the AWS Lambda function created in the previous section with a [REST API](https://en.wikipedia.org/wiki/Representational_state_transfer) created using Amazon API Gateway. You will start by creating your API, then you will bind it to your lambda function. The last part of this section consists of deploying your API.
