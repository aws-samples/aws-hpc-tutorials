+++
title = "g. Set up a Job Definition"
date = 2019-09-18T10:46:30-04:00
weight = 80
tags = ["tutorial", "install", "AWS", "batch", "packer"]
+++

In this step, you will set up a template for your jobs, known as a **Job Definition**. For more information see [Job Definitions](https://docs.aws.amazon.com/batch/latest/userguide/job_definitions.html).

1. In the **AWS Batch Dashboard**, choose **Job definitions** from the left pane, then **Create**.
![AWS Batch](/images/aws-batch/create-job-def-0.png)
2. Select the Single-node option
3. Type **stress-ng-job-definition** as the **Name**.
4. For **Execution timeout**, type **180**. This option specifies the total time the job is expected to run plus some buffer. If the job continues to run after this time you would consider it to have failed.
![AWS Batch](/images/aws-batch/create-job-def-1.png)
5. Select **EC2** as the platform.
6. Choose None for **Execution role**.
![AWS Batch](/images/aws-batch/create-job-def-2.png)
7. Under **Job configuration**, for **Image**, enter the **repositoryUri** generated when you created the **stress-ng** ECR repository. If you do not know the URI, you can use the following command in your terminal to get it.
   ```bash
   aws ecr describe-repositories --repository-names stress-ng --output text --query 'repositories[0].[repositoryUri]'
   ```
8. Clear out the contents of the **Command** text box. You don't want to run any command when your job runs as your container is already set up to excute the docker-entrypoint.sh script when it starts.
![AWS Batch](/images/aws-batch/create-job-def-3.png)
9. For **vCPUs** type **1**.
10. For **Memory (MiB)** type **1024**.
11. Leave the value as blank for **Number of GPUs** field.
![AWS Batch](/images/aws-batch/create-job-def-4.png)
12. Under **Retry Strategies**, for **Job attempts**, type **3**. This option specifies the number of attempts before declaring a job as failed.
![AWS Batch](/images/aws-batch/create-job-def-5.png)
13. Scroll to the bottom of the page and Choose **Create**.
14. Once the Job definition is ready, it will be visible under **Job definitions** grid. Make sure *Status* is **ACTIVE**.
Next you will take a closer look at the **compute environment**, **job queue**, and **job definition** that you have created.
