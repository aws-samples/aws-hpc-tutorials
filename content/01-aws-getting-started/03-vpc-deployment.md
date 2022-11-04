+++
title = "b. Create VPC"
weight = 13
tags = ["tutorial", "vpc", "ParallelCluster"]
+++

![VPC](/images/introductory-steps/vpc.png)

If using a new account, your VPC configuration will consist of one public subnet and a private subnet in the target region. The `p4de` instances come with 4 network cards and need to be placed into a private subnet otherwise instances will not be able to communicate over the network (see [here](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-instance-addressing.html#public-ip-addresses)).

Unless you are comfortable deploying a private subnet, set the routes and security groups, we recommend that you deploy a custom VPC using the CloudFormation template called `VPC-Large-Scale`. This template is region agnostic and enables you to create a VPC with the required network architecture to run your workloads.

Please follow the steps below to deploy your new VPC:

1. Click on this link to deploy to CloudFormation:

    {{% button href="https://us-east-1.console.aws.amazon.com/cloudformation/home?#/stacks/create/review?stackName=VPC-Large-Scale&templateURL=https://smml.hpcworkshops.com/template/VPC-Large-Scale.yaml" icon="fas fa-rocket" %}}Deploy VPC{{% /button %}}

2. You will see a list of parameters, do as follows:

    * In Name of your VPC, leave as default `LargeScaleVPC`.
    * For Availability zone to deploy the subnets, select `us-east-1d`. The public and private subnets will be deployed in this availability zone. This is where your cluster will run.
    * For Availability Zone configuration for the AD subnet, select any availability zone except us-east-1d. A private subnet will be deployed for redundancy on AD.

    Leave the rest as default

3. Click on the Next orange button at the bottom of the page and do it again until landing on the page Step 4: Review.
4. Scroll down to the bottom of the page. Tick the acknowledgement box in the Capabilities section and create stack.

It will take a few minutes to deploy your network architecture. Please proceed to the next section while waiting.