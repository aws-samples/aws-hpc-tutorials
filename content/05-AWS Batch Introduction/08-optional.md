+++
title = "i. Clean up"
date = 2019-09-18T10:46:30-04:00
weight = 120
tags = ["tutorial", "install", "AWS", "batch", "optional"]
+++

Now that you have successfully completed the Batch introduction and Batch Deep Dive workshop you should be familiar with the concepts and operations of AWS Batch. This includes the basic steps required to build and register your own container images; create and run simple and array batch jobs; and the fundementals around AWS Batch architecture. These form the basic building blocks of more complex workflows. 

At this stage it is a good idea to reinforce your knowedge by applying it to address your own problems and workflows.

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

3. Navigate to the [ECR](https://console.aws.amazon.com/ecr/repositories) Dashboard of the AWS Management Console and delete the container repositories you created earlier. (**Or, use the following script to delete all existing repositories**.)
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

4. Either delete the previously created cloudformation stacks using the AWS Management Console or AWS CLI:

- Console: go to [CloudFormation](https://console.aws.amazon.com/cloudformation/)
    1. select the right region and the Batch-Large-Scale stack and click on *Delete*
    2. select the right region and the VPC-Large-Scale stack and click on *Delete*

- CLI: use the following command in your Cloud9 Environment:
```bash
aws cloudformation delete-stack --stack-name Batch-Large-Scale.yaml
aws cloudformation delete-stack --stack-name VPC-Large_Scale.yaml
```
