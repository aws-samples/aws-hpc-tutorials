+++
title = "g. Run a Single Job"
date = 2019-09-18T10:46:30-04:00
weight = 100
tags = ["tutorial", "install", "AWS", "batch", "packer"]
+++

In this step, you launch a job using the AWS CLI. (Note that you could also use the AWS Management Console or the AWS SDK, but this workshop does not cover those options.) 
Use the following commands in AWS CLI to run a [single job](https://docs.aws.amazon.com/batch/latest/userguide/submit_job.html). Make sure to **replace** *YOUR-JOB-QUEUE-NAME* and *YOUR-JOB-DEFINITION-NAME* with the values of the job queue and job definition you just created.

```
aws batch submit-job --job-name my-job --job-queue YOUR-JOB-QUEUE-NAME --job-definition YOUR-JOB-DEFINITION-NAME
```

{{% notice info %}}
If the job does not run, double-check that the job queue name and job definition are correct.
{{% /notice %}}

Keep **track** of the **Job Id** because you can use it to show the status of a job:

```
aws batch describe-jobs --jobs YOUR-JOB-ID
```

A *JSON* displays and describes the status of you job.
