+++
title = "j. Next Steps & Clean up"
date = 2019-09-18T10:46:30-04:00
weight = 120
tags = ["tutorial", "install", "AWS", "batch", "optional"]
+++

Now that you have completed setup, you have many optional next steps. You can generate videos from the simulations, add Lambda functions generate videos, or add Lambda functions to send you notifications once jobs are processed.

#### Generate Videos from Simulations

The results of the simulations are exported to your S3 bucket as ZIP files. You can fetch the files, then view the RGB, segmentation, and depth images. In the AWS Management Console, locate the **S3 Dashboard**, then view your S3 bucket. Or, use the following command to find the name of your S3 bucket:

```bash
S3_BUCKET=$(aws cloudformation describe-stacks --stack-name $STACK_NAME --output text --query 'Stacks[0].Outputs[?OutputKey == `OutputBucket`].OutputValue')
echo 'Your S3 bucket is: $S3_BUCKET'
```

Then, list the content of your bucket using the following command:

```bash
aws s3 ls s3://$S3_BUCKET
```

Next, copy one of the files to your AWS Cloud9 IDE (or desktop) using the following command. Make sure to replace *the_archive_to_retrieve* with your archive name.

```bash
aws s3 cp s3://$S3_BUCKET/the_archive_to_retrieve.tar.gz .
```

After you have fetched and expanded the archive, you can build a movie from the images using the following code. Note that you must install *ffmpeg* yourself.

```bash
convert -quality 100 depth/*.png depth.mp4
convert -quality 100 rgb/*.png rgb.mp4
convert -quality 100 seg/*.png seg.mp4
ffmpeg -i depth.mp4 -i seg.mp4 -i rgb.mp4 -filter_complex "[0:v][1:v][2:v]hstack=3" -c:v libx264 -crf 0 output.mp4
```

#### What Else Can You Do?

You can also do any of the following tasks:

- Set up notifications on job or instance state change using [Amazon CloudWatch Events](https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/WhatIsCloudWatchEvents.html) to [trigger](https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/Create-CloudWatch-Events-Rule.html) an email or SMS notification using [Amazon SNS](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/US_SetupSNS.html).
- Add events to an Amazon DynamoDB table using an [Amazon Lambda function](https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/RunLambdaSchedule.html).
- Use any other example found on [CloudWatch Events Event Examples From Supported Services](https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/EventTypes.html).

Make sure to [let us know](aws-hpc-workshop@amazon.com) what cool things you are building!

#### Clean Up

After you complete the workshop, clean up your environment by following these steps. (Note that you can complete these steps in the AWS Management Console or run the commands in your Cloud9 terminal):

1. Navigate to the [AWS Batch](https://console.aws.amazon.com/batch) Dashboard of the AWS Management Console.
2. Choose **Jobs**. Select any running jobs and choose **Terminate Job**. (Alternatively, you can use the following script to terminate jobs in your Cloud9 environment terminal.)
```bash
cd ~
cat > ~/kill-all-jobs.sh << EOF
#!/bin/bash

JQS=$(aws batch describe-job-queues --query "jobQueues[].[jobQueueName]" --output text)

echo $JQS
for jq in $JQS
do
    for state in SUBMITTED PENDING RUNNABLE STARTING RUNNING
    do
        JOBS=$(aws batch list-jobs --job-queue ${jq} --job-status ${state} --query "jobSummaryList[].[jobId]" --output text)
        if [ ! -z "$JOBS" ]
        then
            for job in $JOBS
            do
                aws batch terminate-job --job-id ${job} --reason 'Terminating job'
                echo "Terminating ${job} in ${jq} with state ${state}"
            done
        fi
    done
done
EOF

bash kill-all-jobs.sh
```
3. Choose **Job definitions**. Select the job definitions you created for this workshop and choose **Actions**, **Deregister**. Job definitions remain inactive for 180 days after which they are deleted. (Or, use the following script to remove all existing job definitions.)
```bash
cd ~
cat > ~/remove-jd.sh << EOF
#!/bin/bash

echo "Removing job definitions"
JD_LIST=$(aws batch describe-job-definitions --query "jobDefinitions[*].[jobDefinitionArn]")
for jd in $JD_LIST
do
    aws batch deregister-job-definition --job-definition $jd
done
EOF

bash remove-jd.sh
```
4. Choose **Job queues**. Select the queues you added for this workshop and choose **Disable**. After the job queues are disabled, select them again and choose **Delete**. (Or, use the following script to delete all job queues.)
```bash
cd ~
cat > ~/remove-jq.sh << EOF
#!/bin/bash

echo "Remove all job queues "
JQ_LIST=$(aws batch describe-job-queues --query "jobQueues[*].jobQueueArn" | jq -r ".[]")
for jq in $JQ_LIST
do
  aws batch delete-job-queue --job-queue $jq
done
EOF

bash remove-jq.sh
```
5. Choose **Compute environments** section. Select the compute environment you created for this workshop and choose **Delete**. Note that job queues must be deleted or disassociated from compute environments before the compute environment can be deleted. You can also run the following script:
```bash
cd ~
cat > ~/remove-ce.sh << EOF
#!/bin/bash

echo "Remove all compute environments "
CE_LIST=$(aws batch describe-compute-environments --query "computeEnvironments[*].computeEnvironmentArn" | jq -r ".[]")
for ce in $CE_LIST
do
  aws batch delete-compute-environments --compute-environment $jq
done
EOF

bash remove-ce.sh
```
6. Navigate to the [ECR](https://console.aws.amazon.com/ecr/repositories) Dashboard of the AWS Management Console and delete the repository you created earlier.

7. Either delete the previously created PrepAVWorkshop stack using the CLI or the AWS Management Console:
- CLI: use the following command in your Cloud9 Environment:
```bash
aws cloudformation delete-stack --stack-name PrepAVWorkshop
```
- Console: go to [CloudFormation](https://console.aws.amazon.com/cloudformation/), select the right region and the PrepAVWorkshop stack and click on *Delete*