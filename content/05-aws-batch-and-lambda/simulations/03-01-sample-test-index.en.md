---
title : "1. Run a small sample"
weight : 31
---

In this session, you will run a small test to price with both AWS Lambda and AWS Batch. You will find AWS Lambda has advantages from run time and cost prospective for this case.

Sample input/output CSV files for the option valuation can be found below:
Input file

![input](/images/batch-lambda/input-10.png)

Output file with the price at the last column

![output](/images/batch-lambda/output-10.png)
After all the components are deployed successfully, you can start to run some tests in following sections.

To run a test, you can simply specify the region and run the ```test.sh``` script under the "fsi-demo" directory:
```bash
export AWS_REGION=us-east-1
./test.sh
```
The script will submit 100 equities and calculate their price on both Batch and Lambda respectively.
```
$ cat test.sh 
#!/bin/bash

echo Running tests with Lambda and Batch in $AWS_REGION region
if [[ -f ~/envVars-$AWS_REGION ]]; then 
  source ~/envVars-$AWS_REGION
else # in CloudBuild environment
  INPUT_BUCKET=fsi-demo-$AWS_REGION-$(echo ${CODEBUILD_BUILD_ARN} | cut -d\: -f5)
fi

# Check if the bucket exists
if ! aws s3 ls $INPUT_BUCKET; then echo please create bucket $INPUT_BUCKET; exit; fi

date;aws s3 cp Data/EquityOption-100.csv s3://$INPUT_BUCKET/fast/100/
date;aws s3 cp Data/EquityOption-100.csv s3://$INPUT_BUCKET/normal/100/
```
After ~1 minute, you can check the metrics under the "Monitor" tab from [Lambda console](https://console.aws.amazon.com/lambda/home?#/functions/fsi-demo?tab=monitoring) to gain some information.

The result will be under the same S3 path in the result bucket with "-result" appended at the end. With following command, you can print out the result from Lambda. The order of the result could be different with input and it can be sorted easily by "id" if needed. 
```bash
source ~/envVars-$AWS_REGION
# Lambda result
aws s3 cp s3://$RESULT_BUCKET/fast/100/EquityOption-100.csv-result -
```

![lambda](/images/batch-lambda/lambda-metrics.png)

From the screenshot above, you can find the maximal duration is about 33 seconds, which is total time from the start to the end of the simulation. In the "total concurrent executions", it shows 11 lambda instances were invoked as the result of one manager process and 10 worker processes for a workload of 100 equities and 10 is set as the number of equities to be processed on each worker.

![batch](/images/batch-lambda/batch-console.png)

After several minutes, you can also check how long it takes with AWS Batch for the same workload from its [console](https://console.aws.amazon.com/batch/home#jobs/fsi-demo/SUCCEEDED). From the screenshot above, the duration of the manager job with name "fsi-demo" from its creation to stop is 159 seconds including time spending on scheduler and instance startup, which is much longer than Lambda for this smaller test. AWS Batch also costs more in this case as the EC2 used by Batch is billed with a minimum of 60 seconds for each instance even an individual child job takes only a couple of seconds.

The result from Batch can be printed on screen with the following command:
```bash
# Batch result
aws s3 cp s3://$RESULT_BUCKET/normal/100/EquityOption-100.csv-result -
```

In the next section, you will run a workload with larger scale using Batch as it would be more cost-effective. 
