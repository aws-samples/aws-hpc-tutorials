+++
title = "g. Run a Single Job"
date = 2019-09-18T10:46:30-04:00
weight = 350
tags = ["tutorial", "install", "AWS", "batch", "packer"]
+++

In this step, you launch a job using the AWS CLI. (Note that you could also use the AWS Management Console or the AWS SDK, but this workshop does not cover those options.) 

Since the Nextflow job is storing the results in Amazon S3 you also need to provide appropriate Amazon S3 access permissions to the **ecsInstanceRole** created as part of the Compute Environment setup. You can attach the **AmazonS3FullAccess** managed policy as below

```bash
aws iam attach-role-policy --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess --role-name ecsInstanceRole --region $AWS_REGION
```

Use the following commands in AWS CLI to run a [single job](https://docs.aws.amazon.com/batch/latest/userguide/submit_job.html). Make sure to **replace** *YOUR-JOB-QUEUE-NAME* and *YOUR-JOB-DEFINITION-NAME* with the values of the job queue and job definition you just created.


```
aws batch submit-job --job-name nextflow-job --job-queue YOUR-JOB-QUEUE-NAME --job-definition YOUR-JOB-DEFINITION-NAME --region $AWS_REGION
```

{{% notice info %}}
If the job does not run, double-check that the job queue name and job definition are correct.
{{% /notice %}}

Keep **track** of the **Job Id** because you can use it to show the status of a job:

```
aws batch describe-jobs --jobs YOUR-JOB-ID
```

A *JSON* displays and describes the status of you job.
