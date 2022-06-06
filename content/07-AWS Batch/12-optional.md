+++
title = "l. Next Steps & Clean up"
date = 2019-09-18T10:46:30-04:00
weight = 120
tags = ["tutorial", "install", "AWS", "batch", "optional"]
+++

Now that you have successfully completed this workshop you should be familiar with the concepts and operations of AWS Batch. This includes the basic steps required to build and register your own container images; create and run simple and array batch jobs; create job dependencies; and share data between jobs using Amazon S3. These form the basic building blocks of more complex workflows. 

At this stage it is a good idea to reinforce your knowedge by applying it to address your own problems and workflows.


#### What else can you do?

You can also do any of the following tasks:

- Set up notifications on job or instance state change using [Amazon CloudWatch Events](https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/WhatIsCloudWatchEvents.html) to [trigger](https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/Create-CloudWatch-Events-Rule.html) an email or SMS notification using [Amazon SNS](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/US_SetupSNS.html).
- Add events to an Amazon DynamoDB table using an [Amazon Lambda function](https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/RunLambdaSchedule.html).
- Use any other example found on [CloudWatch Events Event Examples From Supported Services](https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/EventTypes.html).

Make sure to [let us know](aws-hpc-workshop@amazon.com) what cool things you are building!

#### Clean up

After you complete the workshop, clean up your environment by following these steps. (Note that you can complete these steps in the AWS Management Console or run the commands in your Cloud9 terminal):

1. Navigate to the [AWS Batch](https://console.aws.amazon.com/batch) Dashboard of the AWS Management Console.
2. Choose **Jobs**. Select any running jobs and choose **Terminate Job**. (Alternatively, you can use the following script to terminate jobs in your Cloud9 environment terminal.)
```bash
cd ~
cat > ~/kill-all-jobs.sh << EOF
#!/bin/bash

JQS=\$(aws batch describe-job-queues --query "jobQueues[].[jobQueueName]" --output text)

echo \$JQS
for jq in \$JQS
do
    for state in SUBMITTED PENDING RUNNABLE STARTING RUNNING
    do
        JOBS=\$(aws batch list-jobs --job-queue \${jq} --job-status \${state} --query "jobSummaryList[].[jobId]" --output text)
        if [ ! -z "\$JOBS" ]
        then
            for job in \$JOBS
            do
                aws batch terminate-job --job-id \${job} --reason 'Terminating job'
                echo "Terminating \${job} in \${jq} with state \${state}"
            done
        fi
    done
done
EOF

bash kill-all-jobs.sh
```
3. Choose **Job definitions**. Select the job definitions you created for this workshop and choose **Actions**, **Deregister**. Job definitions remain inactive for 180 days after which they are deleted. (**Or, use the following script to remove all existing job definitions**.)
```bash
cd ~
cat > ~/remove-jd.sh << EOF
#!/bin/bash

echo "Removing all job definitions"
JD_LIST=\$(aws batch describe-job-definitions --query "jobDefinitions[*].[jobDefinitionArn]" | jq -r ".[]" | grep arn | cut -f2 -d\")
for jd in \$JD_LIST
do
    echo "Removing: \$jd"
    aws batch deregister-job-definition --job-definition \$jd
done
EOF

bash remove-jd.sh
```
4. Choose **Job queues**. Select the queues you added for this workshop and choose **Disable**. After the job queues are disabled, select them again and choose **Delete**. (**Or, use the following script to delete all existing job queues**.)
```bash
cd ~
cat > ~/remove-jq.sh << EOF
#!/bin/bash

echo "Removing all job queues "
# Disable the queues.
JQ_LIST=\$(aws batch describe-job-queues --query "jobQueues[*].jobQueueArn" | jq -r ".[]")
for jq in \$JQ_LIST
do
  aws batch update-job-queue --job-queue \$jq --state DISABLED
done

# Wait until they are disabled.
while [ \`aws batch describe-job-queues --query "jobQueues[*].state" | jq -r ".[]" | grep ENABLED | wc -l\` -gt 0 ]
do
    echo "Waiting for job queues to be disabled..."
    sleep 10
done

# Delete the job queues 
for jq in \$JQ_LIST
do
  aws batch delete-job-queue --job-queue \$jq
done

EOF

bash remove-jq.sh
```
1. Choose **Compute environments** section. Select the compute environment you created for this workshop and choose **Delete**. Note that job queues must be deleted or disassociated from compute environments before the compute environment can be deleted. (**Or, use the following script to delete all existing Compute Environments**.)
```bash
cd ~
cat > ~/remove-ce.sh << EOF
#!/bin/bash

echo "Remove all compute environments "
CE_LIST=\$(aws batch describe-compute-environments --query "computeEnvironments[*].computeEnvironmentArn" | jq -r ".[]")
for ce in \$CE_LIST
do
    aws batch update-compute-environment --compute-environment \$ce --state DISABLED
done

# Wait until they are disabled.
while [ \`aws batch describe-compute-environments --query "computeEnvironments[*].state" | jq -r ".[]" | grep ENABLED | wc -l\` -gt 0 ]
do
    echo "Waiting for compute environments to be disabled..."
    sleep 10
done

# Delete the compute environments. 
for jq in \$JQ_LIST
do
  aws batch delete-compute-environment --compute-environment \$ce 
done
EOF

bash remove-ce.sh
```
6. Navigate to the [ECR](https://console.aws.amazon.com/ecr/repositories) Dashboard of the AWS Management Console and delete the container repositories you created earlier. (**Or, use the following script to delete all existing repositories**.)
```bash
cd ~
cat > ~/remove-repos.sh << EOF
#!/bin/bash

echo "Removing all repositories "
REPO_LIST=\$(aws ecr describe-repositories --output text --query "repositories[].[repositoryName]")
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

    # now delete the repository.
    echo "Deleting reposityory: \$repo"
    aws ecr delete-repository --repository-name \$repo
done
EOF

bash remove-repos.sh
```

7. Empty the BatchWorkshop S3 bucket it in the AWS console, or issue the following commands.
```bash
export STRESS_BUCKET="s3://$(aws cloudformation describe-stacks --stack-name $STACK_NAME --output text --query 'Stacks[0].Outputs[?OutputKey == `Bucket`].OutputValue')"
aws s3 rm ${STRESS_BUCKET} --recursive
```
8. Either delete the previously created BatchWorkshop stack using the CLI or the AWS Management Console:
- CLI: use the following command in your Cloud9 Environment:
```bash
aws cloudformation delete-stack --stack-name BatchWorkshop
```
- Console: go to [CloudFormation](https://console.aws.amazon.com/cloudformation/), select the right region and the BatchWorkshop stack and click on *Delete*
