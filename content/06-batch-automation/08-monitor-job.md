+++
title = "h. Monitor your jobs"
date = 2019-09-18T10:46:30-04:00
weight = 400
tags = ["tutorial", "install", "AWS", "batch", "Nextflow"]
+++

In this step, you will monitor your submitted jobs on the Batch console

1. Go to the Batch console and click on the **Dashboard** on the left hand side
![AWS Batch](/images/aws-batch/sc21/mon-1.png)

2. The **Dashboard** gives you an overview of your Batch environment (i.e. Compute Environment, Job Queues and status of the submitted Jobs). The Job queue overview shows the different Job States that a batch job runs through during its execution cycle. For more information about the different job states, see [Job States](https://docs.aws.amazon.com/batch/latest/userguide/job_states.html)
![AWS Batch](/images/aws-batch/sc21/mon-2.png)

3. The Nextflow job you submitted using the command line in the previous step submits one head job and four downstream jobs in the same job queue as part of the genomics pipeline. So you should see a total of 5 succeeded jobs in your output at the end of the run.
![AWS Batch](/images/aws-batch/sc21/mon-3.png)

4. You can view the job logs when the job state is **RUNNING** or **SUCCEDED**. Click on the **SUCCEEDED** jobs and you should see an output as shown below
![AWS Batch](/images/aws-batch/sc21/mon-4.png)

5. Click on one of the jobs and click on the Log stream under Log stream name to see the job output logs in CloudWatch
![AWS Batch](/images/aws-batch/sc21/mon-5.png)

6. The logs should open in CloudWatch in another browser window 
![AWS Batch](/images/aws-batch/sc21/mon-6.png)

