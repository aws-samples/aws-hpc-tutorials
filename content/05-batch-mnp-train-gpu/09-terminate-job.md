---
title : "i. Terminate the Job"
date: 2022-07-22T15:58:58Z
weight : 100
tags : ["configuration", "vpc", "subnet", "iam", "pem"]
---

Terminating the job will automatically clean up the instances since it is a managed environment.

### Terminate the Jobs
- From the AWS Batch console
- Select Dashboard
- Click on the MNP job definition that has the runnable job
- Click on Terminate Job
- AWS Batch will automatically kill the job and release the instances in around 5 minutes
