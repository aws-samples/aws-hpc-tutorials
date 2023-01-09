+++
title = "a. Deploy Pcluster Manager"
weight = 31
tags = ["tutorial", "ParallelCluster"]
+++

ParallelCluster Manager is deployed as a Cloudformation Stack, it'll take about 20 minutes to deploy.

1. Deploy the Pcluster Manager stack by clicking on this button: 
{{% button href="https://us-east-2.console.aws.amazon.com/cloudformation/home?region=us-east-2#/stacks/create/review?stackName=pcluster-manager&templateURL=https://pcm-release-us-east-1.s3.us-east-1.amazonaws.com/pcluster-manager.yaml" icon="fas fa-rocket" %}}Deploy ParallelCluster Manager{{% /button %}}

2. The AWS Console opens on the AWS CloudFormation panel to deploy your stack. Update the field *AdminUserEmail* with **a valid email** to receive a temporary password in order to connect to the Pcluster Manager GUI. Leave the other fields with their default values and click **Next** to proceed to Step 3.

![Pcluster Manager install](/images/deploy-pcm/pcmanager-install.png)

3. Scroll down to the bottom of the Stage 3 page (*Configure stack options*) and click **Next**.
4. Scroll down to the bottom of the Stage 4 page (*Review*) and **click** on the the two tick boxes to create new IAM resources. Once done, click on **Create stack**.

![Pcluster Manager install](/images/deploy-pcm/pcmanager-deploy.png)

The stack is deploying using AWS CloudFormation. It will take ~20 minutes to deploy the AWS ParallelCluster API and Pcluster Manager GUI. In the meantime, you will complete the first part of the lab. Continue to the next page to define the configuration of your first HPC system in AWS.

![Pcluster Manager install](/images/deploy-pcm/pcmanager-stack.png)

{{% notice warning %}}Ensure that you entered a valid email when deploying the Pcluster Manager stack. This email will be used to send you the credentials to connect to Pcluster Manager. If the email you will have to delete and recreate it which may delay your progression.
{{% /notice %}}
