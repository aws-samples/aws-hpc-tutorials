---
title: "c. Delete ParallelCluster UI"
weight: 63
tags: []
---

To delete ParallelCluster UI, navigate to [CloudFormation Console (deeplink)](https://console.aws.amazon.com/cloudformation/home?region=us-east-2#/stacks?filteringStatus=active&filteringText=parallelcluster-ui&viewNested=false&hideStacks=false) > search for `parallelcluster-ui` > **Delete**. Make sure to only delete the parent stack i.e. the one without the **nested** badge. Nested stacks get automatically deleted in the correct order.

This will ask you to confirm.

![Delete ParallelCluster UI](/images/03-cluster/delete-pcmanager.png)

{{% notice note %}}
Deleting ParallelCluster UI does not delete the cluster, to delete the cluster, follow steps in [**b. Delete Cluster**](/06-cleanup/02-delete-cluster.html), or delete the CloudFormation stack with the same name as the cluster. 
{{% /notice %}}