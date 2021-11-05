+++
title = "d. Create a pipeline"
date = 2021-09-30T10:46:30-04:00
weight = 60
tags = ["tutorial", "DeveloperTools", "CodePipeline"]
+++

In this section, you will create a pipeline using [AWS CodePipeline](https://aws.amazon.com/codepipeline/).

AWS CodePipeline is a fully managed [continuous delivery](https://aws.amazon.com/devops/continuous-delivery/) service that helps you automate your release pipelines for fast and reliable application and infrastructure updates. CodePipeline automates the build, test, and deploy phases of your release process every time there is a code change, based on the release model you define

In the first section of this lab you created a CodeCommit repo and created a sample Docker container and corresponding buildspec file to build the container. In the second section of this lab you created a project in CodeBuild and provided the necessary information to compile your created Docker container. 

In this section, you will create a pipeline with a source and build stage to automate the container build and push to Amazon ECR whenever there are any changes in the source CodeCommit repository.

1. In the AWS Management Console search bar, type and select **CodePipeline**.

2. Click on **Create pipeline**

3. In Step 1 **Choose pipeline settings**, enter the Pipeline name as **MyDemoPipeline**. Allow AWS CodePipeline to create a service role to be used with this pipeline. The Role name will default to the following **AWSCodePipelineServiceRole-\<region\>-\<pipelinename\>**. Click **Next**
![AWS CodePipeline](/images/cicd/codepipeline-1.png)

4. In Step 2 **Add source stage**, select **AWS CodeCommit** as your Source provider. Choose **MyDemoRepo** as your repository name where you have pushed your source code. Choose **main** for Branch name. 

5. Keep the default selection for the **Change detection options** and **Output artifact format**. Click **Next**
![AWS CodePipeline](/images/cicd/codepipeline-2.png)

6. In Step 3 **Add build stage**, select **AWS CodeBuild** as your Build provider from the dropdown list. Choose the appropriate **Region**. In the **Project name**, choose the CodeBuild project **MyDemoBuild** that you created in the previous section. You can skip adding the Environment variables as you already provided that in the CodeBuild section. Select **Single build** for the Build type and click **Next**.
![AWS CodePipeline](/images/cicd/codepipeline-3.png)

7. In Step 4 **Add deploy stage**, click on  **Skip deploy stage** as we are building the pipeline in this lab for build automation only. We will focus on deploy/orchestration in the next lab. 
![AWS CodePipeline](/images/cicd/codepipeline-4.png)
![AWS CodePipeline](/images/cicd/codepipeline-9.png)

8. Review your pipeline settings and select **Create pipeline**
 
9. Your pipeline should execute. It will **take a few mins** to execute the pipeline and and if successful should display a message as shown below
![AWS CodePipeline](/images/cicd/codepipeline-5.png)

