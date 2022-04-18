---
title: "c. Delete Pcluster Manager"
weight: 63
tags: []
---

To delete Pcluster Manager, navigate to [CloudFormation Console (deeplink)](https://console.aws.amazon.com/cloudformation/home?region=us-east-2#/stacks?filteringStatus=active&filteringText=pcluster-manager&viewNested=false&hideStacks=false) > search for `pcluster-manager` > **Delete**. Make sure to only delete the parent stack i.e. the one without the **nested** badge. Nested stacks get automatically deleted in the correct order.

This will ask you to confirm.

![Delete Pcluster Manager](/images/pcluster/delete-pcmanager.png)

{{% notice note %}}
Deleting Pcluster Manager does not delete the cluster, to delete the cluster, follow steps in [**b. Delete Cluster**](/06-cleanup/02-delete-cluster.html), or delete the CloudFormation stack with the same name as the cluster. 
{{% /notice %}}