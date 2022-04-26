+++
title = "d. Submit your test jobs"
date = 2019-09-18T10:46:30-04:00
weight = 50
tags = ["tutorial", "install", "AWS", "batch", "packer"]
+++

Congratulations! By this point  you have done the hard part! 

In this section, we are going to submit jobs to the Batch cluster.  The code below submits 1,000 jobs to CE1 which we created using the Batch Architecture template. The jobs are submmited in 2 array jobs, where each array consists of 500 jobs.  AWS Batch will then pick instances from the `c5, c4, m5, m4` families that can fit the jobs.

#### Submit Jobs to AWS Batch
##### Upgrade to AWS CLI Version 2

AWS CLI Version 2 is required to interact with [Amazon ECR](https://aws.amazon.com/ecr/). You will install it by copying, pasting, and executing the following instructions in your terminal window.
1.  **Run** the following commands to upgrade to AWS CLI to Version 2. More information on this process is available at https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html. 
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install -i /usr/local/aws-cli -b /usr/bin
aws --version
```
2. **Confirm** that you now have AWS CLI version 2 sucessfully installed.  **Verify** output from the last command above results in output similar to the following:
```text
aws-cli/2.3.3 Python/3.8.8 Linux/4.14.248-189.473.amzn2.x86_64 exe/x86_64.amzn.2 prompt/off
```

##### Submit jobs
1. **Create** a new file for your submit jobs script. Here you can see the script name is *submitJobs.sh*. Please use whatever you see fit.
2. **Copy and Paste** the code below into the file. **Use** the name of the Batch stack you created in step 2. In this workshop, we used *LargeScaleBatch*.

```bash
#!/bin/bash
TARGET_QUEUE=`aws cloudformation describe-stacks --stack-name LargeScaleBatch --query "Stacks[0].Outputs[?OutputKey=='JobQueue1'].OutputValue" --output text`

JOB_DEFINITION=`aws cloudformation describe-stacks --stack-name LargeScaleBatch --query "Stacks[0].Outputs[?OutputKey=='JobDefinition'].OutputValue" --output text`

# submit 1,000 jobs
for i in {1..2}; do
    aws batch submit-job --job-name StressJQ1CE1Job1 --job-queue ${TARGET_QUEUE} --job-definition ${JOB_DEFINITION} --array-properties '{"size":500}'
done
```
3. **Save** the file.
4. **Run** the script.
```bash
sh submitJobs.sh 
```
5. **Confirm** two array jobs were submitted. You should see output similar to below.
![job submission](/images/aws-batch/deep-dive/terminal_5.png)

Congratulations! You have now submitted 1,000 jobs to AWS Batch using array jobs.

#### Next Steps:
In the next sections, you will dive deep in to AWS Batch basics to understand how AWS Batch manages scaling capacity, job placement, and provisioning of instances by Amazon EC2.
