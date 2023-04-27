+++
title = "c. Install AWS ParallelCluster"
date = 2023-04-10T10:46:30-04:00
weight = 20
tags = ["tutorial", "ParallelCluster", "Manager"]
+++

{{% notice info %}}This lab requires an AWS Cloud9 IDE. If you do not have an AWS Cloud9 IDE set up, complete the steps in *c. Open a Cloud9 Environment* and *d. Work with the AWS CLI* in the **[Preparation](/02-aws-getting-started.html)** section.
{{% /notice %}}

1. In the AWS Management Console search bar, type and select **[Cloud9](https://console.aws.amazon.com/cloud9/home)**. 
![search-cloud9](/images/hpc-aws-parallelcluster-workshop/lab1-pcluster-workshop-03-cloud9_search.png)
2. Choose **open IDE** for the Cloud9 instance set up previously. It may take a few moments for the IDE to open. AWS Cloud9 stops and restarts the instance so that you do not pay compute charges when no longer using the Cloud9 IDE. 
![search-cloud9](/images/hpc-aws-parallelcluster-workshop/lab1-pcluster-workshop-03-cloud9_OpenIDE.png)
A new tab will open with your AWS Cloud9 environment, which will be ready in a few minutes!

![Cloud9 Create](/images/introductory-steps/cloud9-create.png)

3. Use the pip install command to install AWS ParallelCluster. Python and Python package management tool (PIP) are already installed in the Cloud9 environment.
 

Install AWS ParallelCluster version 3.5.1:

```bash
pip3 install aws-parallelcluster==3.5.1 -U --user
```

You can check the ParallelCluster installation completed successfully by running: 

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