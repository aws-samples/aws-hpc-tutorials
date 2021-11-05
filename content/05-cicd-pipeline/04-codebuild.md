+++
title = "c. Setup project in CodeBuild"
date = 2021-09-30T10:46:30-04:00
weight = 50
tags = ["tutorial", "DeveloperTools", "CodeBuild"]
+++

In this section, you will create and setup a build project in [AWS CodeBuild](https://aws.amazon.com/codebuild/).

AWS CodeBuild is a fully managed continuous integration service that compiles source code, runs tests, and produces software packages that are ready to deploy. 

With CodeBuild, you don’t need to provision, manage, and scale your own build servers

1. In the AWS Management Console search bar, type and select **CodeBuild**  Or click on [CodeBuild](https://console.aws.amazon.com/codesuite/codebuild/projects)

2. Click on **Create build project**.

3. In the **Project configuration** section, enter **MyDemoBuild** as the **Project name** and leave the rest as defaults in this section. 

![AWS CodeBuild](/images/cicd/code-build-1.png)

5. In the **Source** section, select **AWS CodeCommit** from the dropdown as the **Source provider**. In the **Repository**, enter the name of the codecommit repository **MyDemoRepo** created earlier. For the **Branch** select the **main** branch (which contains the code, in this case the Docker container to build)

![AWS CodeBuild](/images/cicd/code-build-2a.png)

6. In the **Environment** section, select the settings as shown below
	- Make sure to enable the **Privileged** flag required to build the Docker images
	- Select the **New service role** and let the project create a new service role required for CodeBuild


![AWS CodeBuild](/images/cicd/code-build-3.png)

7. In the **Environment** section, expand the **Additional configuration** section. Keep all settings as default except the following:
  	- Under the **Environment variables**, in the **Name** field enter the Name as **REPOSITORY_URI** 
	- In the **Value** field provide the Amazon ECR repository URI created in the Lab 2 (see below). Keep the Type as default **Plaintext**
	- You can obtain the Amazon ECR repository URI by running the below CLI command on Cloud9, this repo comes from Lab 2.
	- The output should look as **"\<account-id\>.dkr.ecr.\<region\>.amazonaws.com/sc21-container"**. Copy without the quotes and paste in the **Value** field.
 
```bash
REPO_NAME=sc21-container
aws ecr describe-repositories --query repositories[].[repositoryName,repositoryUri] --region $AWS_REGION | grep "/${REPO_NAME}"
 ```

![AWS CodeBuild](/images/cicd/code-build-5.png)

7. In the **Buildspec** section, select **Use a buildspec file** option. By default CodeBuild looks for a file named buildspec.yml in the source code root directory. Since we named our buildspec file as **buildspec.yml** and put it in the root directory of the CodeCommit repo, you can skip providing a name or absolute path
 
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
 

In the next section, you will build a CodePipeline which you will use to automate your container build process


