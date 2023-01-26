---
title : "a. Introduction"
weight : 10
---

This workshop is created to demonstrate how large-scale Monte Carlo simulations can be done with the elastic infrastructure using AWS Batch. In the meantime, smaller workload requiring fast turnaround can also be done timely with near identical application code using AWS Lambda. The same infrastructure can be deployed to a second region optionally to meet compliance and resilience requirements.

![Architecture](/images/batch-lambda/Loosely-coupled.png)

Application operation workflow steps:
1. Users copy an input CSV file with financial asset information to S3 bucket using timestamp as S3 prefix, which could be used as job ID for tracking purpose.
2. A lambda job is triggered with S3 prefix “fast/”, and a Batch job is triggered through EventBridge with S3 prefix “normal/”.
3. The job will be split to multiple input files and put on S3 to run in parallel if above a threshold. For Lambda, the same event-driven process is used to run the job; for Batch, jobs run in parallel with Batch job arrays for efficiency. The input file is processed if it is under a threshold (configurable through environment variable), e.g., 10 equities.
4. The result files are put on an S3 bucket with the same job ID directory.
5. Users get result back by copying from S3 bucket.

