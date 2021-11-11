+++
title = "c. Install the AWS ParallelCluster API"
date = 2019-09-18T10:46:30-04:00
weight = 40
tags = ["tutorial", "initialize", "ParallelCluster"]
+++

You have installed AWS ParallelCluster and will deploy the [AWS ParallelCluster API](https://docs.aws.amazon.com/parallelcluster/latest/ug/api-reference-v3.html) to manage clusters though an API hosted on AWS. This API is used in the second part of the workshop and 20 minutes are required to deploy the stack. We will initiate the deployment now to have it ready by the time you need it.


1. Deploy the Pcluster Manager stack by clicking on this link: [Pcluster Manager Stack](https://console.aws.amazon.com/cloudformation/home?#/stacks/create/parameters?stackName=pcluster-manager&templateURL=https://pcluster-manager-us-east-1.s3.amazonaws.com/pcluster-manager.yaml)
2. The AWS Console opens on the AWS CloudFormation panel to deploy your stack. Update the field *AdminUserEmail* with a valid email to receive a temporary password in order to connect to the Pcluster Manager GUI. Click **Next** to proceed to Step 3.

![Pcluster Manager install](/images/hpc-aws-parallelcluster-workshop/pcmanager-install.png)

3. Scroll down to the bottom of the Stage 3 page (*Configure stack options*) and click **Next**.
4. Scroll down to the bottom of the Stage 4 page (*Review*) and **click** on the the two tick boxes to create new IAM resources. Once done, click on **Create stack**.

![Pcluster Manager install](/images/hpc-aws-parallelcluster-workshop/pcmanager-deploy.png)

The stack is deploying using AWS CloudFormation. It will take ~20 minutes to deploy the AWS ParallelCluster API and Pcluster Manager GUI. During this time, you will complete the first part of the lab. Continue to the next page to create your first HPC system in AWS.
