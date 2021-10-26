+++
title = "i. Cleanup"
date = 2019-09-18T10:46:30-04:00
weight = 500
tags = ["tutorial", "install", "AWS", "batch", "Nextflow"]
+++

Congratulations! You have completed the container orchestration lab and learnt how to deploy your containers using AWS Batch.

In Lab 3 you build and pushed your container to ECR in an automated way using CICD pipeline via CodeCommit and CodeBuild. In Lab 4 you deployed the same container using Batch.
 
In this section, you will clean all the resources that you created in Lab 3 and Lab 4.

#### Clean Up

After you complete the workshop, clean up your environment by following these steps. (Note that you can complete these steps in the AWS Management Console or run the commands in your Cloud9 terminal):

1. Navigate to the [AWS Batch](https://console.aws.amazon.com/batch/home) Dashboard of the AWS Management Console.
2. Choose **Jobs**. Select any running jobs and choose **Terminate Job**. (Alternatively, you can use the following script to terminate jobs in your Cloud9 environment terminal.)
```bash
cd ~
cat > ~/kill-all-jobs.sh << EOF
#!/bin/bash

JQS=$(aws batch describe-job-queues --query "jobQueues[].[jobQueueName]" --output text --region $AWS_DEFAULT_REGION)

echo \$JQS
for jq in \$JQS
do
    for state in SUBMITTED PENDING RUNNABLE STARTING RUNNING
    do
        JOBS=$(aws batch list-jobs --job-queue ${jq} --job-status ${state} --query "jobSummaryList[].[jobId]" --output text --region \$AWS_DEFAULT_REGION)
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
3. Choose **Job definitions**. Select the job definitions you created for this workshop and choose **Actions**, **Deregister**. Job definitions remain inactive for 180 days after which they are deleted. (Or, use the following script to remove all existing job definitions.)
```bash
cd ~
cat > ~/remove-jd.sh << EOF
#!/bin/bash

echo "Removing job definitions"
AWS_DEFAULT_REGION=$(curl --silent http://169.254.169.254/latest/meta-data/placement/region)
export AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}
declare -a JD_LIST
JD_LIST+=($(aws batch describe-job-definitions --query "jobDefinitions[*].[jobDefinitionArn]" --output text --region $AWS_DEFAULT_REGION))
for jd in "\${JD_LIST[@]}"
do
    echo "Removing \$jd"
    aws batch deregister-job-definition --job-definition \$jd --region \$AWS_DEFAULT_REGION
done
EOF

bash remove-jd.sh
```
4. Choose **Job queues**. Select the queues you added for this workshop and choose **Disable** (this has to be done in the Console). After the job queues are disabled, select them again and choose **Delete**. (Or, use the following script to delete all job queues.)
```bash
cd ~
cat > ~/remove-jq.sh << EOF
#!/bin/bash

echo "Remove all job queues "
AWS_DEFAULT_REGION=$(curl --silent http://169.254.169.254/latest/meta-data/placement/region)
export AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}
declare -a JQ_LIST
JQ_LIST+=($(aws batch describe-job-queues --query "jobQueues[*].jobQueueArn" --region $AWS_DEFAULT_REGION | jq -r ".[]"))
for jq in "\${JQ_LIST[@]}"
do
  aws batch delete-job-queue --job-queue \$jq --region \$AWS_DEFAULT_REGION
done
EOF

bash remove-jq.sh
```
5. Choose **Compute environments** section. Select the compute environment you created for this workshop and choose **Disable** (this has to be done in the console). After the compute environments are disabled, select them again and choost **Delete** (or use the following script to delete all compute environments). Note that job queues must be deleted or disassociated from compute environments before the compute environment can be deleted. You can also run the following script:
```bash
cd ~
cat > ~/remove-ce.sh << EOF
#!/bin/bash

echo "Remove all compute environments"
AWS_DEFAULT_REGION=$(curl --silent http://169.254.169.254/latest/meta-data/placement/region)
export AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}
declare -a CE_LIST
CE_LIST+=($(aws batch describe-compute-environments --query "computeEnvironments[*].computeEnvironmentArn" --region $AWS_DEFAULT_REGION | jq -r ".[]"))
for ce in "\${CE_LIST[@]}"
do
  aws batch delete-compute-environment --compute-environment \$ce --region \$AWS_DEFAULT_REGION
done
EOF

bash remove-ce.sh
```
6. Navigate to the [ECR](https://console.aws.amazon.com/ecr/repositories) service in the AWS Management Console and delete the repository you created earlier. Or, run the following CLI command on Cloud9.
```bash
REPO_NAME=sc21-container
aws ecr delete-repository --repository-name $REPO_NAME --force --region $AWS_DEFAULT_REGION
```

7. Navigate to [CodeCommit](https://console.aws.amazon.com/codesuite/codecommit/repositories) in the AWS Management Console and delete the repository you created in Lab 3. Or, run the following CLI command on Cloud9
```bash
CODECOMMIT_REPO_NAME=MyDemoRepo
aws codecommit delete-repository --repository-name $CODECOMMIT_REPO_NAME --region $AWS_DEFAULT_REGION
```

8. Navigate to [CodeBuild](https://console.aws.amazon.com/codesuite/codebuild/projects) in the AWS Management Console and delete the build project you created in Lab 3. Or, run the following CLI command on Cloud9

```bash
CODEBUILD_PROJECT_NAME=MyDemoBuild
aws codebuild delete-project --name $CODEBUILD_PROJECT_NAME --region $AWS_DEFAULT_REGION
```

9. Navigate to [CodePipeline](https://console.aws.amazon.com/codesuite/codepipeline/pipelines) in the AWS Management Console and delete the pipeline that you creared in Lab 3. Or, run the following CLI command on Cloud9

```bash
CODEPIPELINE_NAME=MyDemoPipeline
aws codepipeline delete-pipeline --name $CODEPIPELINE_NAME --region $AWS_DEFAULT_REGION
```

10. Navigate to [IAM](https://console.aws.amazon.com/iamv2/home?#/roles) and delete the following roles created as part of the labs.

- **AWSCodePipelineServiceRole-\<region\>-\<codepipeline-name\>**
- **codebuild-\<codebuild-project-name\>-service-role**
- **ecsInstanceRole**
- **ecsTaskExecutionRole**

