+++
title = "e. Set up Compute Environment"
date = 2019-09-18T10:46:30-04:00
weight = 50
tags = ["tutorial", "install", "AWS", "batch", "packer"]
+++

Start to submit jobs on CE1 by running the commands below. AWS Batch will pick instances from the c5, c4, m5, m4 families that can fit the jobs.

At this point, you have done the hard part! Continue to the next step to set up a job queue.

```bash
#!/bin/bash
TARGET_QUEUE=`aws cloudformation describe-stacks --stack-name BatchStack --query "Stacks[0].Outputs[?OutputKey=='JobQueue1'].OutputValue" --output text`

JOB_DEFINITION=`aws cloudformation describe-stacks --stack-name BatchStack --query "Stacks[0].Outputs[?OutputKey=='JobDefinition'].OutputValue" --output text`

# submit 20,000 jobs
for i in {1..2}; do
    aws batch submit-job --job-name StressJQ1CE1Job1 --job-queue ${TARGET_QUEUE} --job-definition ${JOB_DEFINITION} --array-properties '{"size":10000}'
done
```

