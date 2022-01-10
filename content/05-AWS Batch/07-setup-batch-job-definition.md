+++
title = "g. Set up a Job Definition"
date = 2019-09-18T10:46:30-04:00
weight = 80
tags = ["tutorial", "install", "AWS", "batch", "packer"]
+++

In this step, you will set up a template for your jobs, known as a job definition. A job definition is not required, but is good practice so that you can keep track of how your jobs are launched. For more information about job definitions, see [Job Definitions](https://docs.aws.amazon.com/batch/latest/userguide/job_definitions.html).

1. In the **AWS Batch Dashboard**, choose **Job definitions** from the left pane, then **Create**.
![AWS Batch](/images/aws-batch/job-def/job_def_create.png)
2. Type **stress-ng-job-definition** as the **Job definition name**.
![AWS Batch](/images/aws-batch/create-job-def-1.png)
3. Select **EC2** as the platform.
4. For **Job attempts**, type **3**. This option specifies the number of attempts before declaring a job as failed.
5. For **Execution timeout**, type **180**. This option specifies the total time the job is expected to run plus some buffer. If the job continues to run after this time you would consider it to have failed.
6. For **Container properties**, enter the **repositoryUri** generated when you created the **stress-ng** ECR repository. If you do not know the URI, use the following command in your terminal.
```bash
aws ecr describe-repositories --repository-names stress-ng --output text --query 'repositories[0].[repositoryUri]'
```
![AWS Batch](/images/aws-batch/create-job-def-2.png)
6. Clear out the contents of the **Command** text box. You don't want to run any command when your job runs as your container is already set up to excute the docker-entrypoint.sh script when it starts.
6. For **vCPUs** type **1**.
   
7. For **Memory (MiB)** type **1024**.
   
8. Leave the value as blank for **Number of GPUs** field.

9. Expand the **Additional configuration** section.

10. Leave **Job role** empty and choose None for **Execution role**.
![AWS Batch](/images/aws-batch/create-job-def-3.png)

13. Scroll towards the bottom of the page and Choose **Create**.

14. Once the Job definition is ready, it will be visible under **Job definitions** grid. Make sure *Status* is **ACTIVE**.
![AWS Batch](/images/aws-batch/create-job-def-4.png)

Next, take a closer look at **compute environment**, **job queue**, and **job definition** you created.
