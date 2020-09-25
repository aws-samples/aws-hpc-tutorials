+++
title = "a. Install AWS ParallelCluster"
date = 2019-09-18T10:46:30-04:00
weight = 30
tags = ["tutorial", "install", "ParallelCluster"]
+++

{{% notice info %}}This lab requires an AWS Cloud9 IDE. If you do not have an AWS Cloud9 IDE set up, complete sections *a. Sign in to the Console* through *d. Work with the AWS CLI* in the [**Getting Started in the Cloud**](/02-aws-getting-started.html) workshop.
{{% /notice %}}

1. In the AWS Management Console search bar, type and select **Cloud9**. 
2. Choose **open IDE** for the Cloud9 instance set up previously. It may take a few moments for the IDE to open. AWS Cloud9 stops and restarts the instance so that you do not pay compute charges when no longer using the Cloud9 IDE.
3. Use the pip install command to install AWS ParallelCluster. Python and Python package management tool (PIP) are already installed in the Cloud9 environment.

First, let's upgrade the AWS CLI to get the latest version:

```bash
pip-3.6 install awscli -U --user
```

Install AWS ParallelCluster

```bash
pip-3.6 install aws-parallelcluster -U --user
```

Next, you configure AWS ParallelCluster.