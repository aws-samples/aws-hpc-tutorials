+++
title = "a. Check the API deployment"
date = 2019-09-18T10:46:30-04:00
weight = 30
tags = ["tutorial", "install", "ParallelCluster"]
+++

Before proceeding with the rest of the workshop, ensure that the AWS ParallelCluster API and PCluster Manager have been successfully deployed [Part I](/03-hpc-aws-parallelcluster-workshop/04-initialize-api.html).

You should see **CREATE_COMPLETE** for both stacks as shown in the image below. The AWS ParallelCluster API should appear as **pcluster-manager-AWSParallelClusterAPI-*randomstring*** and PCluster Manager should be named **pcluster-manager**.

![PCluster Manager Deployed](/images/hpc-aws-parallelcluster-workshop/pcmanager-deployed.png)

{{% notice warning %}}If both stacks are successfully deployed, proceed to the next page. If the deployment was unsuccessful, select the **pcluster-manager** stack, click **Delete** and reinstall the stacks using the instructions provided in [Part I](/03-hpc-aws-parallelcluster-workshop/04-initialize-api.html).
{{% /notice %}}
