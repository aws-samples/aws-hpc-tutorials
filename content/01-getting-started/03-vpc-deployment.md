+++
title = "b. Create VPC"
weight = 13
tags = ["tutorial", "vpc", "ParallelCluster"]
+++

![VPC](/images/01-getting-started/vpc.png)

If using a new account, your VPC configuration will consist of one public subnet and a private subnet in the target region. The `p4d` instances come with 4 network cards and need to be placed into a private subnet otherwise instances will not be able to communicate over the network (see [here](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-instance-addressing.html#public-ip-addresses)) and your cluster will fail creation.

Unless you are comfortable deploying a private subnet, set the routes and security groups, we recommend that you deploy a custom VPC using the CloudFormation template called `ML-VPC`. This template is region agnostic and enables you to create a VPC with the required network architecture to run your workloads.

Please follow the steps below to deploy your new VPC:

1. Click on this link to deploy to CloudFormation:

    {{% button href="https://us-east-1.console.aws.amazon.com/cloudformation/home?#/stacks/create/review?stackName=ML-VPC&templateURL=https://aws-hpc-workshops.s3.amazonaws.com/VPC-Large-Scale.yaml" icon="fas fa-rocket" %}}Deploy VPC{{% /button %}}

2. You will see a list of parameters, do as follows:

    * In Name of your VPC, leave as default `ML-VPC`.
    * For Availability zones (AZ's), select all of them. This will deploy a public and private subnet in each AZ. Later we'll specify which one to use.
    * Select the number of AZ's you selected above
    * Keep the S3 Endpoint, Public Subnet and DynamoDB Endpoint as true.

3. Tick the acknowledgement box in the Capabilities section and create the stack.

It will take a few minutes to deploy your network architecture. Please proceed to the next section while waiting.