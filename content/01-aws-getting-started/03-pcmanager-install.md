+++
title = "b. Deploy Pcluster Manager"
weight = 13
tags = ["tutorial", "cloud9", "ParallelCluster"]
+++

The [AWS ParallelCluster API](https://docs.aws.amazon.com/parallelcluster/latest/ug/api-reference-v3.html) has been released with the version 3 of AWS ParallelCluster. It enables you to to manage clusters though an API hosted on AWS and build workflows to manage your cluster lifecycle with Python.

Pcluster Manager is a web UI that built upon the AWS ParallelCluster CLI that you can use to manage your compute clusters. It'll take about 20 minutes to deploy both stacks. You will initiate the deployment now to have it ready by the time you need it.

1. Deploy the Pcluster Manager stack by clicking on this link: [Pcluster Manager Stack](https://console.aws.amazon.com/cloudformation/home?#/stacks/create/parameters?stackName=pcluster-manager&templateURL=https://pcluster-manager-us-east-1.s3.amazonaws.com/pcluster-manager.yaml)
2. The AWS Console opens on the AWS CloudFormation panel to deploy your stack. Update the field *AdminUserEmail* with **a valid email** to receive a temporary password in order to connect to the Pcluster Manager GUI. Leave the other fields with their default values and click **Next** to proceed to Step 3.

![Pcluster Manager install](/images/hpc-aws-parallelcluster-workshop/pcmanager-install.png)
![Pcluster Manager install](/images/hpc-aws-parallelcluster-workshop/pcmanager-stack.png)

3. Scroll down to the bottom of the Stage 3 page (*Configure stack options*) and click **Next**.
4. Scroll down to the bottom of the Stage 4 page (*Review*) and **click** on the the two tick boxes to create new IAM resources. Once done, click on **Create stack**.

![Pcluster Manager install](/images/hpc-aws-parallelcluster-workshop/pcmanager-deploy.png)

The stack is deploying using AWS CloudFormation. It will take ~20 minutes to deploy the AWS ParallelCluster API and Pcluster Manager GUI. In the meantime, you will complete the first part of the lab. Continue to the next page to define the configuration of your first HPC system in AWS.

{{% notice warning %}}Ensure that you entered a valid email when deploying the Pcluster Manager stack. This email will be used to send you the credentials to connect to Pcluster Manager. If the email you will have to delete and recreate it which may delay your progression.
{{% /notice %}}
