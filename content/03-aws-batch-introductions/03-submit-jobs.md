+++
title = "d. Submit your test jobs"
date = 2019-09-18T10:46:30-04:00
weight = 50
tags = ["tutorial", "install", "AWS", "batch", "packer"]
+++

Congratulations! By this point  you have done the hard part! 

In this section, we are going to submit jobs to the Batch cluster through the EC2 instance/Cloud9 IDE from the previous steps. The code below submits 1,000 jobs to CE1 which we created using the Batch Architecture template. The jobs are submitted in 2 array jobs. Each array consists of 500 jobs. AWS Batch will then pick instances from the `c5, c4, m5, m4` families that can fit the jobs.

AWS CLI Version 2 is required to interact with [Amazon ECR](https://aws.amazon.com/ecr/). You will install it by following the procedure below on the command line.

#### To upgrade to AWS CLI Version 2
1. Connect to your EC2 instance or open Cloud9.
2. Run the following commands to upgrade to AWS CLI to Version 2. More information on this process is available [here](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html).
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install -i /usr/local/aws-cli -b /usr/bin
aws --version
```
3. Verify that you have AWS CLI version 2 sucessfully installed by checking the output from the last command above results in similar output to the following:
```text
aws-cli/2.3.3 Python/3.8.8 Linux/4.14.248-189.473.amzn2.x86_64 exe/x86_64.amzn.2 prompt/off
```

#### To submit jobs to AWS Batch
1. Connect to your EC2 instance or open Cloud9.
2. Create a new file called `submitJobs.sh` in your current working directory. 
3. Open the file and write the content below

```bash
#!/bin/bash
TARGET_QUEUE=`aws cloudformation describe-stacks --stack-name LargeScaleBatch --query "Stacks[0].Outputs[?OutputKey=='JobQueue1'].OutputValue" --output text`

JOB_DEFINITION=`aws cloudformation describe-stacks --stack-name LargeScaleBatch --query "Stacks[0].Outputs[?OutputKey=='JobDefinition'].OutputValue" --output text`

# submit 1,000 jobs
for i in {1..2}; do
    aws batch submit-job --job-name StressJQ1CE1Job1 --job-queue ${TARGET_QUEUE} --job-definition ${JOB_DEFINITION} --array-properties '{"size":500}'
done
```
4. Save the file.
5. Run the script.
```bash
sh submitJobs.sh 
```
6. Verify two array jobs were submitted. You should see output similar to below.
![job submission](/images/aws-batch/deep-dive/terminal_5.png)

Congratulations! You have now submitted 1,000 jobs to AWS Batch using array jobs.

#### Next Steps:
In the next sections, you will dive deep in to AWS Batch basics to understand how AWS Batch manages scaling capacity, job placement, and provisioning of instances by Amazon EC2.
