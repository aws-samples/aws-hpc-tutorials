+++
title = "c. Setup project in CodeBuild"
date = 2021-09-30T10:46:30-04:00
weight = 50
tags = ["tutorial", "DeveloperTools", "CodeBuild"]
+++

In this section, you will create and setup a build project in [AWS CodeBuild](https://aws.amazon.com/codebuild/).

AWS CodeBuild is a fully managed continuous integration service that compiles source code, runs tests, and produces software packages that are ready to deploy. 

With CodeBuild, you don’t need to provision, manage, and scale your own build servers



1. In the AWS Management Console search bar, type and select **CodeBuild**. Double check that you are using CodeBuild in the same AWS Region that you have used in the previous steps.

2. Click on **Create build project**.

3. In the **Project configuration** section, enter **MyDemoBuild** as the **Project name** and leave the rest as defaults in this section. 

![AWS CodeBuild](/images/cicd/code-build-1.png)

5. In the **Source** section, select **AWS CodeCommit** from the dropdown as the **Source provider**. In the **Repository**, enter the name of the codecommit repository **MyDemoRepo** created earlier. For the **Branch** select the **main** branch (which contains the code, in this case the Docker container to build)

![AWS CodeBuild](/images/cicd/code-build-2a.png)

6. In the **Environment** section, select the settings as shown below
	- Make sure to enable the **Privileged** flag required to build the Docker images
	- Select the **New service role** and let the project create a new service role required for CodeBuild


![AWS CodeBuild](/images/cicd/code-build-3.png)

7. Expand the **Additional configuration** section and, in the **Environment** section, keep all settings as default except the following:
  	- Under the **Environment variables**, in the **Name** field enter the Name as **REPOSITORY_URI** 
	- In the **Value** field provide the Amazon ECR repository URI created the last step (see below). Keep the Type as default **Plaintext**
	- You can obtain the Amazon ECR repository URI by running the below CLI command on Cloud9, this repo comes from Lab 2.
	- The output should look as **"\<account-id\>.dkr.ecr.\<region\>.amazonaws.com/sc22-container"**. Copy without the quotes and paste in the **Value** field.
 
```bash
export IMAGE_URI=$(aws ecr describe-repositories --repository-name sc22-container --query "repositories[0].repositoryUri" --output text)                                                                                                                                                
echo $IMAGE_URI
```

![AWS CodeBuild](/images/cicd/code-build-5.png)

7. In the **Buildspec** section, select **Use a buildspec file** option. By default CodeBuild looks for a file named buildspec.yml in the source code root directory.  We will create a **buildspec.yml** file in a later step.
 
8. Keep the defaults in **Batch configuration** and **Artifacts** section.

![AWS CodeBuild](/images/cicd/code-build-6.png)

9. In the **Logs** section enable the **CloudWatch logs**. This option will upload the build output logs to [CloudWatch](https://aws.amazon.com/cloudwatch/)

10. Click on **Create build project**

![AWS CodeBuild](/images/cicd/code-build-4.png)

11. Since the CodeBuild is going to interact with Amazon ECR, the CodeBuild service role created requires additional permissions. In the **Cloud9** terminal, execute the following 

```bash
aws iam attach-role-policy --policy-arn arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess --role-name codebuild-MyDemoBuild-service-role
```

When executing the above if you run into an error as shown below, it means you have not disabled AWS managed temporary credentials in Cloud9 as covered in the [Preparation](/02-aws-getting-started.html) section of the Lab. 
Kindly fix that and re-do the above step.
![AWS CodeBuild](/images/cicd/code-build-temp-cred-error.png)
 

12. Create a buildspec file to build and push the Docker container to [Amazon ECR](https://aws.amazon.com/ecr/)

A [buildspec](https://docs.aws.amazon.com/codebuild/latest/userguide/build-spec-ref.html) is a collection of build commands and related settings in YAML format. This file is used by [AWS CodeBuild](https://docs.aws.amazon.com/codebuild/latest/userguide/welcome.html) to automatically create an updated version of the container upon code changes. The buildspec file informs CodeBuild of all the actions that should be taken during a build run for your application. In the next section, you will dive deeper on what is CodeBuild and how to set it up as part of a pipeline. 
```bash

cat > buildspec.yml << EOF
version: 0.2

phases:
  pre_build:
    commands:
      - echo Logging in to Amazon ECR...
      - aws --version
      - \$(aws ecr get-login --region \$AWS_REGION --no-include-email)
      - IMAGE_TAG=\$(echo \$CODEBUILD_RESOLVED_SOURCE_VERSION | cut -c 1-8)
      - echo IMAGE TAG \$IMAGE_TAG

  build:
    commands:
      - echo Build started at \$(date)
      - echo Building the Docker image...
      - docker build -t \$REPOSITORY_URI:latest .
      - docker tag \$REPOSITORY_URI:latest \$REPOSITORY_URI:\$IMAGE_TAG

  post_build:
    commands:
      - echo Build completed at $(date)
      - echo Pushing the Docker images...
      - docker push \$REPOSITORY_URI:latest
      - docker push \$REPOSITORY_URI:\$IMAGE_TAG

EOF
```

13. Commit the buildspec file and push to the CodeCommit repository.

```
git add buildspec.yml
git commit -m "add build specification file"
git push
```

In the next section, you will build a CodePipeline which you will use to automate your container build process