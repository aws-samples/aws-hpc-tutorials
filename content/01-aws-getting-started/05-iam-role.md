+++
title = "e. Post Event: Temporary credentials on Cloud9 (Skip)"
date = 2019-09-18T10:46:30-04:00
weight = 50
tags = ["tutorial", "install", "IAM"]
+++

In this step, you will turn off the temporary credentials managed by Cloud9.
Your AWS Cloud9 instance has been created for this lab with the IAM role that allows your Cloud9 instance to access any services of your AWS account

AWS Identity and Access Management (IAM) enables you to manage access to AWS services and resources securely.
Using IAM, you can create and manage AWS users and groups, and use permissions to allow and deny their access to AWS resources.


1. In Cloud9, choose the gear icon in top right corner to open a new tab and choose "Preferences” tab.

2. In the Preferences tab, choose **AWS Settings** to turn off **AWS managed temporary credentials**, then close the Preferences tab.

![Getting Started](/images/introductory-steps/cloud9-credentials.png)
