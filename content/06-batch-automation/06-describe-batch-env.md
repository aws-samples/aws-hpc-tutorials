+++
title = "f. Describe Your Environment"
date = 2019-09-18T10:46:30-04:00
weight = 300
tags = ["tutorial", "install", "AWS", "batch"]
+++

Now that you have configured AWS Batch, take a look at your environment by using the following commands

```bash
aws batch describe-compute-environments --region $AWS_REGION
```

```bash
aws batch describe-job-queues --region $AWS_REGION
```

```bash
aws batch describe-job-definitions --region $AWS_REGION
```

You will see that the *JSONs* provided as output contain the parameters you chose for the compute environment, job queue, and job definition. Keep in mind that the steps you completed previously using the AWS Console can also be completed with the AWS CLI, AWS SDK, or AWS CloudFormation.

