+++
title = "g. Connect to PCluster Manager"
date = 2019-09-18T10:46:30-04:00
weight = 70
tags = ["tutorial", "initialize", "ParallelCluster"]
+++

{{%notice note%}}
If you are participating in this workshop as part of SC22, then *PCluster Manager* will already be deployed for you. 
{{% /notice %}}

Once your PCluster Manager CloudFormation stack has been deployed, you can follow these steps to connect to it:

1. Open the [AWS CloudFormation console](https://console.aws.amazon.com/cloudformation/home).

2. You'll see two stacks named **mod-[random hash]**. Click on the second stack (**mod-187330a4e44c489a**), then click on the **Outputs** tab, and finally click on the **PclusterManagerUrl** to connect to PCluster Manager.

![PCluster Manager Deployed](/images/sc22/pcluster-deployed.png)

