+++
title = "d. Upload to Amazon ECR"
date = 2019-09-18T10:46:30-04:00
weight = 40
tags = ["tutorial", "install", "AWS", "batch", "Docker", "ECR"]
+++

In this step, you will create a private container repository in [Amazon Elastic Container Registry (Amazon ECR)](https://aws.amazon.com/ecr/) and upload your newly created container image for use with AWS Batch. The AWS Management Console is used for these steps, however later in the workshop you will use AWS CLI commands to accomplish these tasks.

### Create an Amazon ECR Repository
1. Navigate to [Amazon ECR](https://console.aws.amazon.com/ecr/home).
2. Click on the **Create repository** button in the top right.
![AWS Batch](/images/aws-batch/create-repo-1.png)
3. Name the new repository **stress-ng**. 
![AWS Batch](/images/aws-batch/create-repo-2.png)
4. Leave all the other options as the default and click the **Create repository** button at the bottom right.


### Upload your Container to the Repository

1. Select your new repository and click on the **View push commands** button.
![AWS Batch](/images/aws-batch/create-repo-3.png)

You should see a set of four commands similar to the following.
![AWS Batch](/images/aws-batch/create-repo-4.png)

2. Cut and paste each of the commands for your repository (similar to those shown above) into a teminal on your Cloud9 instance and execute them. 
{{% notice info %}}
   You can safely skip the second command as you have previously built your container image.
{{% /notice %}}

   The commands have the the following effects:

- The first command obtains your credentials and logs into the repository.

- The second command builds and tags the container image from the definition contained in the Dockerfile in the current directory.

- The third command tags the image in the reposiory.

- The fourth command "pushes" (uploads) the image to the repository.

3. After successfully executing these commands, if you click on your repository you will see the image stress-ng:latest image that you just pushed.
![AWS Batch](/images/aws-batch/create-repo-5.png)

4. Click on the icon next to "Copy URI" to copy the URI of your container image. 
. 
{{% notice info %}}
This **Image URI** will be used when you create a Batch Job definition in the next stage of this workshop.
{{% /notice %}}

If you click on the **latest** image tag you will reveal the details of your image including its URI.
![AWS Batch](/images/aws-batch/create-repo-6.png)


