+++
title = "h. Connect to the Cluster"
date = 2022-04-10T10:46:30-04:00
weight = 80
tags = ["tutorial", "create", "ParallelCluster"]
+++

Once you are connected to Pcluster Manager, you can see the created cluster, depending on timing this cluster might be in **CREATE_IN_PROGRESS** or **CREATE_COMPLETE** state.

#### What's Happening in the Background

When the **pcluster create-cluster** command is executed, AWS ParallelCluster generates an [AWS CloudFormation](https://aws.amazon.com/cloudformation/) template to generate an infrastructure in AWS. If you want to see AWS CloudFormation generating the infrastructure, you can view the **Stack Events** tab to see cluster creation events in real time:

![ParallelCluster CloudFormation](/images/sc22/PCM.png)

Once the cluster goes into **CREATE COMPLETE**, you can connect to the head node via SSM.

## SSM Connect

You can connect to your cluster via SSH using SSM.

**SSM Connect** It doesn't require any ports to be open on the head node, however it does require you to authenticate with the AWS account the instance it running in.

1. Click on the **Shell** Button to connect:

![SSM Connect](/images/sc22/PCM_Shell.png)

You'll need to be authenticated to the AWS account that instance is running in and have [permission to launch a SSM session](https://docs.aws.amazon.com/systems-manager/latest/userguide/getting-started-add-permissions-to-existing-profile.html). Once you're connected you'll have access to a terminal on the head node:

![SSM Console](/images/sc22/ssm-console.png)


## DCV Connect (Optional)

**DCV** is a full graphical remote desktop that allows you to run GUI applications on the head node. It doesn't require AWS account access but does require you to be able to connect to the head node on port **8443**.

1. Click on the **DCV** Button to connect:

![DCV Connect](/images/sc22/PCM_DCV.png)

2. As a one-time step since DCV uses self-signed certificates you'll need to click on **Advanced** > **Proceed to Unsafe**:

![Browser Warning](/images/sc22/browser-warning.png)

3. Next to launch a terminal we'll click **Activities** > **Terminal**:

![DCV Terminal](/images/sc22/dcv-terminal.png)


