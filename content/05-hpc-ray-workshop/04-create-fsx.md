---
title: "d. Create FSx for Luster Filesystem"
date: 2022-08-18
weight: 50
tags: ["Ray", "FSx"]
---

We will use AWS console to create FSxL.

- Navigate to Amazon FSx console and click on Create file system
- Select Amazon FSx for Luster and click Next
- For filesystem name, choose **ray-fsx**
- Next set the storage capacity to 1.2 TB. Leave other values as default.
- Under Network & Security settings, select ray-vpc, ray-cluster-sg and a subnet.

![ray-fsx-network-setting](/images/hpc-ray-workshop/ray-fsx-network-setting.png)

FSxL can only exist in one Availability Zone. Therefore, we will spin up the ray cluster in the same subnet as the one used here.
