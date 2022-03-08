+++
title = "n. Next Steps & Clean up"
date = 2019-09-18T10:46:30-04:00
weight = 130
tags = ["tutorial", "install", "AWS", "batch", "optional"]
+++

Now that you have successfully completed this workshop you should be familiar with the concepts and operations of AWS Batch. This includes the basic steps required to build and register your own container images; create and run single and array batch jobs; create job dependencies; share data between jobs using Amazon S3; and decribe AWS Batch infrastructure and the status of jobs. These actions form the basic building blocks of more complex workflows that can be accomplished with AWS Batch. At this stage it is a good idea to reinforce your knowedge by applying these techniques to address your own problems and workflows.


### What else can you do?

Some related tasks that may be beneficial to try at this stage include:

- Try out [Workflow orchestration](https://console.aws.amazon.com/batch/home#stepfunctions) using [AWS Step Functions](https://aws.amazon.com/step-functions/) accessible from the [AWS Batch](https://console.aws.amazon.com/batch) Dashboard.
- Set up notifications on [job ](https://docs.aws.amazon.com/batch/latest/userguide/batch_cwe_events.html) or [instance or service](https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-service-event.html) state changes using [Amazon EventBridge](https://docs.aws.amazon.com/eventbridge/) - for example to create a [rule ](https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-create-rule.html) that reacts to events by sending an email or SMS notification using [Amazon SNS](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/US_SetupSNS.html).
- Process  [Amazon EventBridge](https://docs.aws.amazon.com/eventbridge/) events using an [AWS Lambda function](https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-run-lambda-schedule.html).
- Read input or store ouput in  [Amazon DynamoDB](https://aws.amazon.com/dynamodb/) tables.

Make sure to [let us know](aws-hpc-workshop@amazon.com) what cool things you are building!

### Clean up

After you have completed all of the previous workshop steps and finished experimenting you can clean up your environment by following the instructions below. Note that you can complete each step in either the AWS Management Console or by running the specified commands in a terminal on your Cloud9 instance.

#### Terminate running jobs

1. Navigate to the [AWS Batch](https://console.aws.amazon.com/batch) Dashboard of the AWS Management Console.
2. Choose **Jobs**. Select any running jobs and choose **Terminate Job**. 

Alternatively, you can use the following script to terminate jobs in any queues with names that match "stress".
```bash
cd ~/environment/
cat > kill-all-jobs.sh << EOF
#!/bin/bash
MATCH=stress
echo "Terminating all jobs in queues that match \"\$MATCH\""...
JQS=\$(aws batch describe-job-queues --query "jobQueues[].[jobQueueName]" --output text | grep \$MATCH)

for jq in \$JQS
do
    echo "Terminating jobs in queue: \$jq"
    for state in SUBMITTED PENDING RUNNABLE STARTING RUNNING
    do
        JOBS=\$(aws batch list-jobs --job-queue \$jq --job-status \$state --query "jobSummaryList[].[jobId]" --output text)
        if [ ! -z "\$JOBS" ]
        then
            for job in \$JOBS
            do
                aws batch terminate-job --job-id \$job --reason 'Terminating job'
                echo "Terminating \$job in \$jq with state \$state"
            done
        fi
    done
done
EOF

bash kill-all-jobs.sh
```
#### Deregister job definitions
1. Choose **Job definitions**. Select the job definitions you created for this workshop and choose **Actions** / **Deregister**. Job definitions remain inactive for 180 days after which they are deleted.

Or, use the following script to deregister all job definitions with names that match "stress".
```bash
cd ~/environment/
cat > remove-jd.sh << EOF
#!/bin/bash
MATCH=stress
echo "Deregistering all job definitions that match \"\$MATCH\""...
JD_LIST=\$(aws batch describe-job-definitions --query "jobDefinitions[*].[jobDefinitionArn]" | jq -r ".[]" | grep arn | cut -f2 -d\" | grep \$MATCH)
for jd in \$JD_LIST
do
    echo "Deregistering: \$jd"
    aws batch deregister-job-definition --job-definition \$jd
done
EOF

bash remove-jd.sh
```
#### Disable and remove job queues
1. Choose **Job queues**. Select the queues you added for this workshop and choose **Disable**. After the job queues are disabled, select them again and choose **Delete**. 

Or, use the following script to delete all job queues with names that match "stress".
```bash
cat > ~/remove-jq.sh << EOF
#!/bin/bash
MATCH=stress
echo "Removing all job queues that match \"\$MATCH\""
# Disable the queues.
JQ_LIST=\$(aws batch describe-job-queues --query "jobQueues[*].jobQueueArn" | jq -r ".[]" | grep \$MATCH)
for queue in \$JQ_LIST
do
    # Disable the job queue.
    aws batch update-job-queue --job-queue \$queue --state DISABLED

    # Wait until queue is disabled.
    while [ \`aws batch describe-job-queues --job-queue \$queue --query "jobQueues[*].state" | jq -r ".[]" | grep DISABLED | wc -l\` -ne 1 ]
    do
        echo "Waiting for job queue \$queue to be disabled..."
        sleep 10
    done

    # Wait until queue status is valid.
    while [ \`aws batch describe-job-queues --job-queue \$queue --query "jobQueues[*].status" | jq -r ".[]" | grep VALID | wc -l\` -ne 1 ]
    do
        echo "Waiting for job queue \$queue status to become valid..."
        sleep 10
    done

    # Delete the job queue.
    aws batch delete-job-queue --job-queue \$queue
done
EOF

bash ~/remove-jq.sh
```
5. Choose **Compute environments** and select the compute environment you created for this workshop and choose **Delete**. Note that job queues must be deleted or disassociated from compute environments before the compute environment can be deleted. 

Or, use the following script to delete all Compute Environments with names that match "stress".
```bash
cat > ~/remove-ce.sh << EOF
#!/bin/bash
MATCH=stress
echo "Removing all compute environments that match \"\$MATCH\""
CE_LIST=\$(aws batch describe-compute-environments --query "computeEnvironments[*].computeEnvironmentArn" | jq -r ".[]" | grep \$MATCH)
for ce in \$CE_LIST
do
    # Disable the compute environment.
    aws batch update-compute-environment --compute-environment \$ce --state DISABLED

    # Wait until they are disabled.
    while [ \`aws batch describe-compute-environments --compute-environment \$ce --query "computeEnvironments[*].state" | jq -r ".[]" | grep DISABLED | wc -l\` -ne 1 ]
    do
        echo "Waiting for compute environments to be disabled..."
        sleep 10
    done

    # Wait until the status bevomes VALID.
    while [ \`aws batch describe-compute-environments --compute-environment \$ce --query "computeEnvironments[*].status" | jq -r ".[]" | grep VALID | wc -l\` -ne 1 ]
    do
        echo "Waiting for compute environment \$ce status to become valid..."
        sleep 10
    done

    # Delete the compute environment. 
    aws batch delete-compute-environment --compute-environment \$ce 
done
EOF

bash ~/remove-ce.sh
```
#### Delete ECR repositories
6. Navigate to the [ECR](https://console.aws.amazon.com/ecr/repositories) Dashboard of the AWS Management Console and delete the container repositories you created earlier. 

Or, use the following script to delete all images and repositories with names that match "stress".
```bash
cd ~/environment/
cat > remove-repos.sh << EOF
#!/bin/bash
MATCH=stress
echo "Removing all repositories that match \"\$MATCH\""
REPO_LIST=\$(aws ecr describe-repositories --output text --query "repositories[].[repositoryName]" | grep \$MATCH)
for repo in \$REPO_LIST
do
    echo "Deleting images in \$repo"
    IMAGE_LIST=\$(aws ecr describe-images --repository-name \$repo --output text --query "imageDetails[].[imageTags]")
    for tag in \$IMAGE_LIST
    do
        echo "Deleting image: \$repo:\$tag"
        aws ecr batch-delete-image --repository-name \$repo --image-ids imageTag=\$tag
    done

    # Wait until all images are deleted.
    while [ \`aws ecr describe-images --repository-name \$repo --output text --query "imageDetails[].[imageTags]" | wc -l\` -gt 0 ]
    do
        echo "Waiting for images in \$repo to be deleted..."
        sleep 10
    done

    # Delete the repository.
    echo "Deleting reposityory: \$repo"
    aws ecr delete-repository --repository-name \$repo
done
EOF

bash remove-repos.sh
```
#### Empty the S3 bucket
7. Go to [Amazon S3](https://console.aws.amazon.com/s3/) in the AWS Console and empty the bucket belonging to the **BatchWorkshop** CloudFormation stack. 

Or, use the following commands.
```bash
export STRESS_BUCKET="s3://$(aws cloudformation describe-stacks --stack-name $STACK_NAME --output text --query 'Stacks[0].Outputs[?OutputKey == `Bucket`].OutputValue')"
aws s3 rm ${STRESS_BUCKET} --recursive
```
#### Delete the CloudFormation stack
1. Go to [AWS CloudFormation](https://console.aws.amazon.com/cloudformation/) in the AWS Console and delete the **BatchWorkshop** stack. 

Or, use the following commands.
```bash
aws cloudformation delete-stack --stack-name BatchWorkshop
```

Congratulations, you have now completed this AWS Batch Workshop. 
