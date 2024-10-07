+++
title = "a. Deploy ParallelCluster UI"
weight = 21
tags = ["tutorial", "ParallelCluster"]
+++

ParallelCluster UI is deployed as a CloudFormation Stack, it'll take about 20 minutes to deploy.

1. Deploy the ParallelCluster UI stack by clicking on this button:
{{% button href="https://us-east-2.console.aws.amazon.com/cloudformation/home?region=us-east-2#/stacks/create/review?stackName=parallelcluster-ui&templateURL=https://parallelcluster-ui-release-artifacts-us-east-1.s3.us-east-1.amazonaws.com/parallelcluster-ui.yaml" icon="fas fa-rocket" %}}Deploy ParallelCluster UI{{% /button %}}

2. The AWS Console opens on the AWS CloudFormation panel to deploy your stack. Update the field *AdminUserEmail* with **a valid email** to receive a temporary password in order to connect to the ParallelCluster UI GUI. Leave the other fields with their default values and click **Next** to proceed to Step 3.

![ParallelCluster UI install](/images/deploy-pcm/pcmanager-install.png)

3. Scroll down to the bottom of the Stage 3 page (*Configure stack options*) and click **Next**.
4. Scroll down to the bottom of the Stage 4 page (*Review*) and **click** on the the two tick boxes to create new IAM resources. Once done, click on **Create stack**.

![ParallelCluster UI install](/images/deploy-pcm/pcmanager-deploy.png)

The stack is deploying using AWS CloudFormation. It will take ~20 minutes to deploy the AWS ParallelCluster API and ParallelCluster UI. Please grab a ☕️ while you wait.

{{% notice warning %}}Ensure that you entered a valid email when deploying the ParallelCluster UI stack. This email will be used to send you the credentials to connect to ParallelCluster UI. If the email you will have to delete and recreate it which may delay your progression.
{{% /notice %}}
