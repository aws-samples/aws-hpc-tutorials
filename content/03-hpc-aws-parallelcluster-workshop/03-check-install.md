+++
title = "b. Check the stacks installation"
date = 2019-09-18T10:46:30-04:00
weight = 30
tags = ["tutorial", "initialize", "ParallelCluster"]
+++

Before proceeding with the rest of the workshop, ensure that the AWS ParallelCluster API and PCluster Manager have been successfully deployed after going through the [preparation stage](/02-aws-getting-started/04-pcluster-stacks.html).

1. Got to the AWS Console, in the search box search for AWS CloudFormation and click on the icon. You can alternatively [**click on this link**](https://console.aws.amazon.com/cloudformation/home).

2. Check if the pc-manager stack has the state **CREATE_COMPLETE** for both stacks as shown in the image below. The AWS ParallelCluster API should appear as **pcluster-manager-AWSParallelClusterAPI-*randomstring*** and PCluster Manager should be named **pcluster-manager**.

![PCluster Manager Deployed](/images/hpc-aws-parallelcluster-workshop/pcmanager-deployed.png)

{{% notice warning %}}If both stacks are successfully deployed, proceed to the next page. If the deployment was unsuccessful, select the **pcluster-manager** stack, click **Delete** and reinstall the stacks using the instructions provided in [Part I](/02-aws-getting-started/04-pcluster-stacks.html).
{{% /notice %}}

3. When deploying the PCluster Manager stack you provided an email to receive the credentials. Check this email inbox for an email from Cognito that will look like the one in the image below.

![PCluster Manager](/images/hpc-aws-parallelcluster-workshop/pcm-email.png)

You are good to go to the next stages if you received the credentials email and verified that the stacks are deployed. Otherwise, contact one of the lab owners to get some help.
