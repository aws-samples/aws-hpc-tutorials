+++
title = "Before Proceeding"
date = 2023-04-10T10:46:30-04:00
weight = 20
tags = ["tutorial", "ParallelCluster"]
+++

{{% notice info %}}This lab requires an AWS Cloud9 IDE. If you do not have an AWS Cloud9 IDE set up, complete sections *a. Sign in to the Console* through *d. Work with the AWS CLI* in the **[Getting Started in the Cloud](/02-aws-getting-started.html)** workshop.
{{% /notice %}}

The first part of this lab is to run a script to provision some base resources.

These include a Aurora MySQL database to hold the Slurm accounting Information and two HPC Clusters. These clusters whilst both running in AWS are going to be representing an On-Prem Cluster and a Cloud Cluster.

Please login to Cloud9 and ensure that you have set Cloud9 to run with Admin rights. Run the command below, the output you get may vary a little. The important thing is to check the Arn and make sure it includes the string "WorkshopRole". If the output includes the string ParticipantRole then you do not have admin rights. 

To fix the setting if needed, in Cloud9, click on the settings Icon in the top right, it looks like a little cog. Select AWS Settings, you may need to scroll the menu. Finally ensure that "AWS Managed Credentials" is turned off.

Example showing the correct permissions in Cloud9.
```bash
WSParticipantRole:~/environment $ aws sts get-caller-identity
{
    "UserId": "AROA4LTLX6YAXT46ZLN4P:i-08bc17a8ba3b8c143",
    "Account": "XXXXXXXXXXXX",
    "Arn": "arn:aws:sts::XXXXXXXXXXXX:assumed-role/mycloud9env-WorkshopRole-12AX2RWD6TIRM/i-08bc17a8ba3b8c143"
}
```

If this looks good, please proceed.