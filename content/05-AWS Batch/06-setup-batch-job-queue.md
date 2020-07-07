+++
title = "e. Set up a Job Queue"
date = 2019-09-18T10:46:30-04:00
weight = 70
tags = ["tutorial", "install", "AWS", "batch", "packer"]
+++

In this step, you set up a job queue. This job queue is where you submit your jobs. These jobs are dispatched to the compute environment(s) of your choosing by order of priority. If you want to learn more about job queues, see [Job Queues](https://docs.aws.amazon.com/batch/latest/userguide/job_queues.html).

1. In the **AWS Batch Dashboard**, choose **Job queues**, then choose **Create queue**.
![AWS Batch](/images/aws-batch/batch8.png)
2. Type a **Queue name**.
3. Choose a **Priority** (1-500). You can pick any value for this workshop. This option defines the priority of a job queue when a compute environment is shared across job queues. Job queues with a higher priority (or a higher integer value for the priority parameter) are evaluated first when associated with the same compute environment. Priority is determined in descending order, for example, a job queue with a priority value of 10 is given scheduling preference over a job queue with a priority value of 1.
4. For **Compute environment**, choose the Compute Environment you created previously.
5. Choose **Create Job Queue**.

![AWS Batch](/images/aws-batch/batch9.png)

Continue to set up a job definition.




