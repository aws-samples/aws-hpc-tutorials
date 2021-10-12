+++
title = "h. Describe Your Environment"
date = 2019-09-18T10:46:30-04:00
weight = 90
tags = ["tutorial", "install", "AWS", "batch", "Docker"]
+++

Now that you have configured AWS Batch, take a look at your environment by using the following commands:

```bash
aws batch describe-compute-environments
```

```bash
aws batch describe-job-queues
```

```bash
aws batch describe-job-definitions
```

You will see that the *JSON* documnets provided as output for each of these commands that contain the parameters you chose when you set up the **compute environment**, **job queue**, and **job definition**. Keep in mind that the steps you completed up to this point using the AWS management Console can also be completed with the AWS CLI, AWS SDK, or AWS CloudFormation.

