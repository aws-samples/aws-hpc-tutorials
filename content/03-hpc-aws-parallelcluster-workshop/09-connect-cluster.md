+++
title = "h. Connect to the Cluster"
date = 2022-04-10T10:46:30-04:00
weight = 90
tags = ["tutorial", "create", "ParallelCluster"]
+++

The cluster we created on the previous page takes about ~10 mins to create. While you're waiting grab a ☕️.

Once the cluster goes into **CREATE COMPLETE**, we can connect to the head node in one of the following three ways, either through the shell, via the DCV, or via SSH:

**SHELL** is ideal for quick terminal access to the head node.

**DCV** is a full graphical remote desktop that allows you to run GUI applications on the head node. It doesn't require AWS account access but does require you to be able to connect to the head node on port **8443**.

**SSH** is ideal for accessing the command line and/or moving (small) files onto the cluster (using *scp*). It does require to open port 22 (open by default).

## SSM Connect

**SSM Connect** It doesn't require any ports to be open on the head node, however it does require you to authenticate with the AWS account the instance it running in.

1. Click on the **Shell** Button to connect:

![SSM Connect](/images/isc22/ssm-connect.png)

You'll need to be authenticated to the AWS account that instance is running in and have [permission to launch a SSM session](https://docs.aws.amazon.com/systems-manager/latest/userguide/getting-started-add-permissions-to-existing-profile.html). Once you're connected you'll have access to a terminal on the head node:

![SSM Console](/images/isc22/ssm-console.png)

## DCV Connect

1. Click on the **DCV** Button to connect:

![DCV Connect](/images/isc22/dcv-connect.png)

2. As a one-time step since DCV uses self-signed certificates you'll need to click on **Advanced** > **Proceed to Unsafe**:

![Browser Warning](/images/isc22/browser-warning.png)

3. Next to launch a terminal (where the rest of the lab will run) we'll click **Activities** > **Terminal**:

![DCV Terminal](/images/isc22/dcv-terminal.png)


## SSH

1. from the Cloud9 machine terminal, run the following:

```bash
source env_vars
pcluster ssh -n ISC22 -i ~/.ssh/$SSH_KEY_NAME -r $AWS_REGION      
```

