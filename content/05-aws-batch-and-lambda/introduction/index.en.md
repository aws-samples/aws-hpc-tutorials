---
title : "a. Introduction"
weight : 10
---

In this workshop, you will experiment how to run large-scale Monte Carlo simulations with the elastic infrastructure using AWS Batch. In the meantime, you will use AWS Lambda to run smaller workload requiring fast turnaround with the same container image used for AWS Batch. You can also choose to deploy the same infrastructure to a second region with the same procedure to meet compliance and resilience requirements.

![Architecture](/images/batch-lambda/Loosely-coupled.png)

Application operation workflow steps:
1. Upload an input CSV file with financial asset information to S3 bucket using timestamp as S3 prefix, which could be used as job ID for tracking purpose.
2. A lambda job is triggered with S3 prefix “fast/”, and a Batch job is triggered through EventBridge with S3 prefix “normal/”.
3. The job will be split to multiple input files and put on S3 to run in parallel if above a threshold. For Lambda, the same event-driven process is used to run the job; for Batch, jobs run in parallel with Batch job arrays for efficiency. The input file is processed if it is under a threshold (configurable through environment variable), e.g., 10 equities.
4. The result files are put on an S3 bucket with the same job ID directory.
5. Users get result back by copying from S3 bucket.

