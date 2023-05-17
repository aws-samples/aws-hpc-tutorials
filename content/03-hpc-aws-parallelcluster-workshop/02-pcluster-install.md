+++
title = "b. Install AWS ParallelCluster"
date = 2023-04-10T10:46:30-04:00
weight = 20
tags = ["tutorial", "ParallelCluster", "Install"]
+++


{{% notice info %}}This lab requires an AWS Cloud9 IDE. If you do not have an AWS Cloud9 IDE set up, complete sections *b. Open a Clou9 Environment* through *d. Temporary credentials on Cloud9* in the **[Preparation](/02-aws-getting-started.html)** workshop.
{{% /notice %}}

#### Load Cloud9 IDE

If the Cloud9 IDE isn't currently loaded:

1. In the AWS Management Console search bar, type and select **Cloud9**. 
2. Choose **open IDE** for the Cloud9 instance set up previously. It may take a few moments for the IDE to open. AWS Cloud9 stops and restarts the instance so that you do not pay compute charges when no longer using the Cloud9 IDE. 

#### Installing AWS ParallelCluster

Use the pip install command to install AWS ParallelCluster. Python and Python package management tool (PIP) are already installed in the Cloud9 environment.


Install AWS ParallelCluster version 3.5.1:

```bash
pip3 install aws-parallelcluster==3.5.1 -U --user
```

This will take a couple of minutes. You can check the ParallelCluster installation has completed successfully by running: 

```bash
pcluster version
```

The output should be:
```bash
{
  "version": "3.5.1"
}
```

Next, you will configure AWS ParallelCluster.