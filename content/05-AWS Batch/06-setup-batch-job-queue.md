+++
title = "f. Set up a Job Queue"
date = 2019-09-18T10:46:30-04:00
weight = 70
tags = ["tutorial", "install", "AWS", "batch", "packer"]
+++

In this step, you will set up a job queue. You submit your jobs to a queue and they are dispatched to compute environment(s) in order of priority. If you want to learn more about job queues, see [Job Queues](https://docs.aws.amazon.com/batch/latest/userguide/job_queues.html).

1. In the **AWS Batch Dashboard**, choose **Job queues** from the left pane, then choose **Create job queue** or **Create**.
![AWS Batch](/images/aws-batch/create-queue-1.png)
2. Under the **Job queue configuration** section, type **stress-ng-queue** as the **Job Queue name**. 
3. Choose a **Priority** of 1 for this workshop, but you can pick any value between 1 and 500. This option defines the priority of a job queue when a compute environment is shared across job queues. Job queues with a higher priority (or a higher integer value for the priority parameter) are evaluated first when associated with the same compute environment. Priority is determined in descending order, for example, a job queue with a priority value of 10 is given scheduling preference over a job queue with a priority value of 1.
4. Expand the **Additional configuration** section and ensure that **State** is selected as **Enabled**.
5. For **Tags**, optionally enter names and values for your tags. This is optional but it is considered a good practice to tag your resources.
![AWS Batch](/images/aws-batch/create-queue-2.png)
6. Under **Connected compute environments**, select the **stress-ng-ec2** compute environment that you created previously.
![AWS Batch](/images/aws-batch/create-queue-3.png)

7. Choose **Create**.
8. Once the job queue is ready, it will be visible under **Job queues** section. Make sure its *State* is **ENABLED** and *Status* is **VALID**.
![AWS Batch](/images/aws-batch/create-queue-4.png)


Continue to the next step to set up a job definition.
