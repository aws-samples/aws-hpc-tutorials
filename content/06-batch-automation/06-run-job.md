+++
title = "f. Run a Single Job"
date = 2019-09-18T10:46:30-04:00
weight = 300
tags = ["tutorial", "install", "AWS", "batch", "packer"]
+++

In this step, you launch a job using the AWS CLI. (Note that you could also use the AWS Management Console or the AWS SDK to submit jobs, but this workshop does not cover those options.) 

Run the following command on Cloud9 terminal to run a [single job](https://docs.aws.amazon.com/batch/latest/userguide/submit_job.html)..


```bash
aws batch submit-job --job-name nextflow-job --job-queue nextflow-jq --job-definition nextflow-demo --region $AWS_REGION
```

{{% notice info %}}
If the job does not run, double-check that the job queue name and job definition are correct.
{{% /notice %}}

Once your job is submitted successfully, note the **Job Id** because you can use it to show the status of a job:

```bash
aws batch describe-jobs --jobs <your-job-id> --region $AWS_REGION
```

A *JSON* displays and describes the status of you job.
