+++
title = "b. Define a new IAM policy"
date = 2019-09-18T10:46:30-04:00
weight = 50
tags = ["tutorial", "IAM", "ParallelCluster", "Serverless"]
+++

[Identity and Access Management](https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction.html) (IAM) controls who or what can conduct actions on resources. For example, an instance can be allowed to access the APIs to create new instances. In the present case, you will enable the nodes of your cluster to access the AWS Systems Manager (SSM) endpoints so commands triggered by your Lambda function can be executed on them using SSM.

In this section you will:

- Create an Amazon S3 bucket to store your Slurm `sbatch` scripts and the SSM commands logs for auditing.
- Define an new new [IAM policy](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html) that enables the cluster instances to access SSM and access the S3 bucket.
