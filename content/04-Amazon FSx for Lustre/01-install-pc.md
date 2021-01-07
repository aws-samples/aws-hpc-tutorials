+++
title = "a. Install AWS ParallelCluster"
date = 2019-09-18T10:46:30-04:00
weight = 20
tags = ["tutorial", "install", "ParallelCluster"]
+++

{{% notice info %}}If you already have AWS ParallelCluster installed on your AWS Cloud9 instance, you can skip this step.
{{% /notice %}}

1. In the AWS Management Console search bar, type **Cloud9**, then select **Cloud9**.
2. Choose **open IDE** for the Cloud9 instance set up previously. It may take a few moments for the IDE to open. AWS Cloud9 stops and restarts the instance so that you do not pay compute charges when no longer using the Cloud9 IDE.

Use the pip install command to install AWS ParallelCluster. Python and Python package management tool (PIP) are already installed in the Cloud9 environment.

```bash
pip3 install aws-parallelcluster -U --user
```

Then upgrade the AWS CLI to get the latest version:

```bash
pip3 install awscli -U --user
```
