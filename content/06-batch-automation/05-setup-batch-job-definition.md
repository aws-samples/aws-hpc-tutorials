+++
title = "e. Set up a Job Definition"
date = 2019-09-18T10:46:30-04:00
weight = 250
tags = ["tutorial", "install", "AWS", "batch", "nextflow"]
+++

In this step, you set up a template used for your jobs, known as a job definition. A job definition is not required, but a good practice to use so that you can version how your jobs are launched. For more information about job definitions, see [Job Definitions](https://docs.aws.amazon.com/batch/latest/userguide/job_definitions.html).

1. In the **AWS Batch Dashboard**, choose **Job definitions** from the left pane, then **Create**.
![AWS Batch](/images/aws-batch/sc21/jd-1.png)
2. Type a **Job definition name**. For platform select **EC2**
3. For **Job attempts**, type **3**. This option specifies the number of attempts before declaring a job as failed.
![AWS Batch](/images/aws-batch/sc21/jd-2.png)
4. For **Execution timeout**, type **200**. This option specifies the time between attempts in seconds.
5. For **Container Image**, enter the **REPOSITORY URI** generated when you created the ECR repository. If you do not know the URI, use the following command in your Cloud9 terminal.
```bash
aws ecr describe-repositories --repository-names sc21-container --output text --query 'repositories[0].[repositoryUri]' --region $AWS_REGION
```
6. Update the contents of the **Command** text box to point to the **entrypoint.sh** script which will execute the Nextflow head job when your job runs.
![AWS Batch](/images/aws-batch/sc21/jd-3.png)
7. For **vCPUs** type **16**.
8. For **Memory (MiB)** type **1024**.
9. Leave the value as blank for **Number of GPUs** field.
![AWS Batch](/images/aws-batch/sc21/jd-4.png)
10. Expand the **Additional configuration** section.
11. For **Job role** and **Execution role** choose **ecsTaskExecutionRole** created in section b. of this lab.
12. Skip to the **Environment variables** section. Click **Add** and add the four environment variables as shown below
	- **PIPELINE_URL** variable points to the Nextflow tutorial github repository. This can also be an Amazon S3 bucket URI.
	- **NF_SCRIPT** variable points to the script to execute. This script executes a sample genomics pipeline using Nextflow.
	- **BUCKET_NAME_RESULTS** variable points to the S3 bucket created in Section a. of this Lab to store the results of the Nextflow pipeline run. 
	- **NF_JOB_QUEUE** variable points to the job-queue name to execute the downstream Nextflow jobs. 
![AWS Batch](/images/aws-batch/sc21/jd-5.png)
13. Scroll towards the bottom of the page and Choose **Create**.
![AWS Batch](/images/aws-batch/sc21/jd-6.png)
14. Once the Job definition is ready, it will be visible under **Job definitions**. Make sure *Status* is **ACTIVE**.
![AWS Batch](/images/aws-batch/sc21/jd-7.png)

Next, take a closer look at **compute environment**, **job queue**, and **job definition** you created.
