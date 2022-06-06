---
title: "b. Connect to the Cluster"
weight: 52
tags: ["tutorial", "cloud9", "ParallelCluster"]
---

The cluster we created on the previous page takes about ~15 mins to create. While you're waiting grab a ☕️.

Once the cluster goes into **CREATE COMPLETE**, we can connect to the head node in one of two ways, either through the shell or via the DCV session:

**SSM Session Manager** is ideal for quick terminal access to the head node, it doesn't require any ports to be open on the head node, however it does require you to authenticate with the AWS account the instance it running in.

**DCV** is a full graphical remote desktop that allows you to run GUI applications on the head node. It doesn't require AWS account access but does require you to be able to connect to the head node on port **8443**.

## SSM Connect

1. Click on the **Shell** Button to connect:

![SSM Connect](/images/pcluster/ssm-connect.png)

You'll need to be authenticated to the AWS account that instance is running in and have [permission to launch a SSM session](https://docs.aws.amazon.com/systems-manager/latest/userguide/getting-started-add-permissions-to-existing-profile.html). Once you're connected you'll have access to a terminal on the head node:

![SSM Console](/images/pcluster/ssm-console.png)

## DCV Connect

1. Click on the **DCV** Button to connect:

![DCV Connect](/images/pcluster/dcv-connect.png)

2. As a one-time step since DCV uses self-signed certificates you'll need to click on **Advanced** > **Proceed to Unsafe**:

![Browser Warning](/images/pcluster/browser-warning.png)

3. Next to launch a terminal (where the rest of the lab will run) we'll click **Activities** > **Terminal**:

![DCV Terminal](/images/pcluster/dcv-terminal.png)