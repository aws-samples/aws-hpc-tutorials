+++
title = "b. Connect to PCluster Manager (Lab)"
date = 2019-09-18T10:46:30-04:00
weight = 30
tags = ["tutorial", "initialize", "ParallelCluster"]
+++

{{%notice note%}}
If you are participating in this workshop as part of re:Invent, then *PCluster Manager* will already be deployed for you.
{{% /notice %}}

Once your PCluster Manager CloudFormation stack has been deployed, you can follow these steps to connect to it:

1. Go to the AWS Console and use the search box to search for [AWS CloudFormation](https://console.aws.amazon.com/cloudformation/home).

2. Once **CloudFormation** appears in your search results, click on it to open the CloudFormation Management Console.

3. You'll see a stack named **mod-[random hash]**. Click on that stack, then click on the **Outputs** tab, and finally click on the **PclusterManagerUrl** to connect to PCluster Manager.

![PCluster Manager Deployed](/images/hpc-aws-parallelcluster-workshop/pcluster-deployed.png)

4. Next, click on **Sign Up** to create a username and password for accessing PCluster Manager.

![Signup Screen](/images/hpc-aws-parallelcluster-workshop/sign-up.png)
