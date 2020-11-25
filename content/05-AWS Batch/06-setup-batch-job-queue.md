+++
title = "f. Set up a Job Queue"
date = 2019-09-18T10:46:30-04:00
weight = 70
tags = ["tutorial", "install", "AWS", "batch", "packer"]
+++

In this step, you set up a job queue. This job queue is where you submit your jobs. These jobs are dispatched to the compute environment(s) of your choosing by order of priority. If you want to learn more about job queues, see [Job Queues](https://docs.aws.amazon.com/batch/latest/userguide/job_queues.html).

1. In the **AWS Batch Dashboard**, choose **Job queues** from the left pane, then choose **Create job queue** or **Create**.
![AWS Batch](/images/aws-batch/job-queue/job_queue_create.png)
2. Under **Job queue configuration** section, type a **Job queue name**.
3. Choose a **Priority** (1-500). You can pick any value for this workshop. This option defines the priority of a job queue when a compute environment is shared across job queues. Job queues with a higher priority (or a higher integer value for the priority parameter) are evaluated first when associated with the same compute environment. Priority is determined in descending order, for example, a job queue with a priority value of 10 is given scheduling preference over a job queue with a priority value of 1.
4. Expand the **Additional configuration** section and validate that **State** is selected as **Enabled**.
![AWS Batch](/images/aws-batch/job-queue/job_queue_config.png)
5. For **Tags *optional***, enter the values for your tags. This is optional but is considered a good practice to tag your resources.
6. Under **Connected compute environments**, select a compute environment that you created previously.
7. Choose **Create**.
![AWS Batch](/images/aws-batch/job-queue/job_queue_tags_compute_env.png)
8. Once the job queue is ready, it will be visible under **Job queues** section. Make sure *State* is **ENABLED** and *Status* is **VALID**.
![AWS Batch](/images/aws-batch/job-queue/job_queue_display.png)

Continue to set up a job definition.




