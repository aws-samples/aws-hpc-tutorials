+++
title = "e. Disable temporary credentials"
date = 2019-09-18T10:46:30-04:00
weight = 80
tags = ["tutorial", "install", "IAM"]
+++

Amazon Cloud9 enviroment are setup with temporary AWS credentials to access and perform actions on resources.
In this step, you will disable the temporary credentials to use the IAM role attached to the Amazon EC2 of Cloud9.

In the **MyCloud9Env** Cloud9 environment:

1. Once the Cloud9 environment is created.
1. Choose the **gear icon** in the top right to open the Prefences tab.
1. In the **Preferences** tab, choose **AWS SETTINGS**.
1. Turn off the **AWS managed temporary credentials**.
1. Close the **Preferences** tab.


![Getting Started](/images/introductory-steps/cloud9-credentials.png)