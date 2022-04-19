+++
title = "e. Submit your test jobs"
date = 2019-09-18T10:46:30-04:00
weight = 50
tags = ["tutorial", "install", "AWS", "batch", "packer"]
+++

At this point, you have done the hard part! 

Submit your jobs on CE1 by running the commands below. AWS Batch will pick instances from the `c5, c4, m5, m4` families that can fit the jobs.

```bash
#!/bin/bash
TARGET_QUEUE=`aws cloudformation describe-stacks --stack-name BatchStack --query "Stacks[0].Outputs[?OutputKey=='JobQueue1'].OutputValue" --output text`

JOB_DEFINITION=`aws cloudformation describe-stacks --stack-name BatchStack --query "Stacks[0].Outputs[?OutputKey=='JobDefinition'].OutputValue" --output text`

# submit 1,000 jobs
for i in {1..2}; do
    aws batch submit-job --job-name StressJQ1CE1Job1 --job-queue ${TARGET_QUEUE} --job-definition ${JOB_DEFINITION} --array-properties '{"size":500}'
done
```

In the next workshop you will dive deep in to AWS Batch basics to understand how AWS Batch manages scaling capacity, job placement, and provisioning of instances by Amazon EC2.