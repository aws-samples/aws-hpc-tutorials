+++
title = "e. Set up Compute Environment"
date = 2019-09-18T10:46:30-04:00
weight = 50
tags = ["tutorial", "install", "AWS", "batch", "packer"]
+++

In this step, you set up an AWS Batch Compute Environment using the AWS Management Console.

Compute environments can be seen as computational clusters. They can consist of one or several instance kinds or just the number of cores you want in the environment. For more information on the compute environments, see [Compute Enviornments](https://docs.aws.amazon.com/batch/latest/userguide/compute_environments.html).

1. In the AWS Management Console, in the search bar, search for and choose **Batch**. Choose **Get started**.
![AWS Batch](/images/aws-batch/batch1.png)
2. On the next screen, choose **Skip wizard**.
![AWS Batch](/images/aws-batch/batch2.png)
3. In the left pane, choose **Compute environments**, then choose **Create environment**.
![AWS Batch](/images/aws-batch/batch3.png)
4. For **Compute environment type**, choose **Managed**. This option allows AWS Batch manage the automatic scaling of EC2 resources for you.
5. Type a **Compute environment name**.
6. For **Service role**, choose **Create a new role** so that AWS Batch can manage resources on your behalf.
7. For **Instance role**, choose **Create a new role** to allow instances to call AWS APIs on your behalf.
8. Leave the **EC2 key pair** field as is, do not provide a key pair.
![AWS Batch](/images/aws-batch/batch4.png)
9. For **Provisioning model**, choose **On-Demand**.
10. For **Allowed instance type**, remove **optimal** and choose **g3s.xlarge**.
11. For **Maximum vCPUs** type **16** (which allows you to use up to 4 instances).
12. Skip the other vCPU settings.
![AWS Batch](/images/aws-batch/batch5.png)
13. Select the **Enable user-specified Ami ID** check box, then type the ID of the AMI generated with Packer. Choose **Validate AMI** and you should see a similar result to the following image.
![AWS Batch](/images/aws-batch/batch6.png)
14. For **VPI Id**, choose the default VPC.
15. Choose all subnets.
16. For **Security groups**, leave the selection as the default.
17. For **Placement groups**, leave the selection as the default.
18. Add a **Tag** called **Name** and for **Value**, type a name for your instances created with Batch. You can add additional tags if you want.
19. Choose **Create** to build your new compute environment.
![AWS Batch](/images/aws-batch/batch7.png)

At this point, you have done the hard part! Continue to set up a job queue.



