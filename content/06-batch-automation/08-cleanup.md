+++
title = "h. Cleanup"
date = 2019-09-18T10:46:30-04:00
weight = 450 
tags = ["tutorial", "install", "AWS", "batch", "Nextflow"]
+++

Congratulations! You have completed the container orchestration lab and learnt how to deploy your containers using AWS Batch.

In Lab 3 you build and pushed your container to ECR in an automated way using CICD pipeline via CodeCommit and CodeBuild. In Lab 4 you deployed the same container using Batch.
 
In this section, you will clean all the resources that you created in Lab 3 and Lab 4.

#### Clean Up

After you complete the workshop, clean up your environment by following these steps:

1. On the Cloud9 terminal run the following commands to delete the AWS Batch environment & resources you created:

```bash
aws cloudformation delete-stack --stack-name nextflow-batch-ce-jq --region $AWS_REGION
aws cloudformation delete-stack --stack-name nextflow-batch-jd --region $AWS_REGION
```

2. Navigate to the [AWS CloudFormation](https://console.aws.amazon.com/cloudformation/home) Dashboard of the AWS Management Console and confirm that the stacks are deleted.

 
3. Navigate to the [ECR](https://console.aws.amazon.com/ecr/repositories) service in the AWS Management Console and delete the repository you created earlier. Or, run the following CLI command on Cloud9.
```bash
REPO_NAME=sc21-container
aws ecr delete-repository --repository-name $REPO_NAME --force --region $AWS_REGION
```

4. Navigate to [CodeCommit](https://console.aws.amazon.com/codesuite/codecommit/repositories) in the AWS Management Console and delete the repository you created in Lab 3. Or, run the following CLI command on Cloud9
```bash
CODECOMMIT_REPO_NAME=MyDemoRepo
aws codecommit delete-repository --repository-name $CODECOMMIT_REPO_NAME --region $AWS_REGION
```

5. Navigate to [CodeBuild](https://console.aws.amazon.com/codesuite/codebuild/projects) in the AWS Management Console and delete the build project you created in Lab 3. Or, run the following CLI command on Cloud9

```bash
CODEBUILD_PROJECT_NAME=MyDemoBuild
aws codebuild delete-project --name $CODEBUILD_PROJECT_NAME --region $AWS_REGION
```

6. Navigate to [CodePipeline](https://console.aws.amazon.com/codesuite/codepipeline/pipelines) in the AWS Management Console and delete the pipeline that you creared in Lab 3. Or, run the following CLI command on Cloud9

```bash
CODEPIPELINE_NAME=MyDemoPipeline
aws codepipeline delete-pipeline --name $CODEPIPELINE_NAME --region $AWS_REGION
```

7. Navigate to [IAM](https://console.aws.amazon.com/iamv2/home?#/roles) and delete the following Policies  (click on **Policies** on the left hand pane) created as part of the labs. Search for the below policies. Click on the Policy -> Action -> Delete. Follow the required steps to confirm deletion.  

- CodeBuildBasePolicy-**\<codebuild-project-name\>-\<region\>**
- AWSCodePipelineServiceRole-**\<region\>-\<codepipeline-name\>**

8. Navigate to [IAM](https://console.aws.amazon.com/iamv2/home?#/roles) and delete the following Roles (click on **Roles** on the left hand pane) created as part of the labs. Search for the below roles. Click on the Role -> Action -> Delete. Follow the required steps to confirm deletion.

- AWSCodePipelineServiceRole-**\<region\>-\<codepipeline-name\>**
- codebuild-**\<codebuild-project-name\>**-service-role
- ecsTaskExecutionRole




