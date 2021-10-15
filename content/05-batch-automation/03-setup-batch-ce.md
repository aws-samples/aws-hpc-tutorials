+++
title = "c. Set up Compute Environment"
date = 2019-09-18T10:46:30-04:00
weight = 150
tags = ["tutorial", "install", "AWS", "batch", "packer"]
+++

In this step, you set up an AWS Batch Compute Environment using the AWS Management Console.

Compute environments can be seen as computational clusters. They can consist of one or several instance kinds or just the number of cores you want in the environment. For more information on the compute environments, see [Compute Environments](https://docs.aws.amazon.com/batch/latest/userguide/compute_environments.html).

1. In the AWS Management Console, in the search bar, search for and choose **Batch**.
2. In the left pane, choose **Compute environments** option and click **Create**
![AWS Batch](/images/aws-batch/sc21/ce-1.png)
3. Under **Compute environment configuration**, choose **Managed** for **Compute environment type**. This option allows AWS Batch manage the automatic scaling of EC2 resources for you.
4. Type a **Compute environment name**.
5. Check **Enable compute environment**. This option enables the AWS Batch environment when it's ready.
![AWS Batch](/images/aws-batch/sc21/ce-7.png)
6. Under **Instance configuration**, choose **On-demand** for **Provisioning model**. This option allows AWS Batch manage the automatic scaling of EC2 resources for you.
![AWS Batch](/images/aws-batch/sc21/ce-3.png)
7. After you choose **On-demand** provisioning model, scroll back up and expand the **Additional settings: service role, instance role, EC2 key pair** section under **Compute environment configuration**
8. For **Service role**, choose **Batch service-linked role**. The role allows the AWS Batch service to make calls to other AWS services on your behalf. For more information, see [Using service-linked roles for AWS Batch](https://docs.aws.amazon.com/batch/latest/userguide/using-service-linked-roles.html).
9. For **Instance role**, choose **Create a new role**. This instance profile allows the Amazon ECS container instances that are created for your compute environment to make calls to the required AWS API operations on your behalf. For more information, see [Amazon ECS Instance Role](https://docs.aws.amazon.com/batch/latest/userguide/instance_IAM_role.html). If you choose to create a new instance profile, the required role (ecsInstanceRole) is created for you.
10. Leave the **EC2 key pair** field as is, do not provide a key pair.
![AWS Batch](/images/aws-batch/sc21/ce-2.png)
11. Leave the default value of **0** for **Minimum vCPUs**.
12. For **Maximum vCPUs** type **256**
13. Leave the default value of **0** for **Desired vCPUs - optional**.
14. For **Allowed instance types** choose **optimal**.
15. Select **BEST_FIT** for **Allocation strategy**
![AWS Batch](/images/aws-batch/sc21/ce-4.png)
16. Under Networking, for **VPC ID** and **subnets** leave the defaults which should be default VPC and all subnets
17. Under **EC2 tags - optional**, Add a **Tag** called **Name** and for **Value**, type **Nextflow Batch** as a name for your instances created with Batch. You can add additional tags if you want.
18. Choose **Create compute environment** to build your new compute environment.
![AWS Batch](/images/aws-batch/sc21/ce-5.png)
19. Once the environment is ready, it will be visible under **Compute environments** section. Make sure *Status* is **VALID** and *State* is **ENABLED**. 
This will take around a minute (refresh to check the Status updates).
![AWS Batch](/images/aws-batch/sc21/ce-6.png)

At this point, you have done the hard part! Continue to set up a job queue.



