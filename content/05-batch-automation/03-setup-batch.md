+++
title = "c. Set up Compute Environment"
date = 2019-09-18T10:46:30-04:00
weight = 150
tags = ["tutorial", "install", "AWS", "batch", "packer"]
+++

In this step, you set up an AWS Batch Compute Environment using the AWS Management Console.

Compute environments can be seen as computational clusters. They can consist of one or several instance kinds or just the number of cores you want in the environment. For more information on the compute environments, see [Compute Environments](https://docs.aws.amazon.com/batch/latest/userguide/compute_environments.html).

1. In the AWS Management Console, in the search bar, search for and choose **Batch**.
2. In the left pane, choose **Compute environments**, then choose **Create compute environment** or **Create**.
![AWS Batch](/images/aws-batch/compute-env/batch_create_environment.png)
3. Under **Compute environment configuration**, choose **Managed** for **Compute environment type**. This option allows AWS Batch manage the automatic scaling of EC2 resources for you.
4. Type a **Compute environment name**.
5. Check **Enable compute environment**. This option enables the AWS Batch environment when it's ready.
6. For **Service role**, choose **Batch service-linked role**. The role allows the AWS Batch service to make calls to other AWS services on your behalf. For more information, see [**Using service-linked roles for AWS Batch**](https://docs.aws.amazon.com/batch/latest/userguide/using-service-linked-roles.html).
7. Under **Instance configuration**, choose **On-demand** for **Provisioning model**. This option allows AWS Batch manage the automatic scaling of EC2 resources for you.
8. After you choose **On-demand** provisioning model, scroll back up and expand the **Additional settings: service role, instance role, EC2 key pair** section under **Compute environment configuration**
9. For **Instance role**, choose **Create a new role**. This instance profile allows the Amazon ECS container instances that are created for your compute environment to make calls to the required AWS API operations on your behalf. For more information, see [**Amazon ECS Instance Role**](https://docs.aws.amazon.com/batch/latest/userguide/instance_IAM_role.html). If you choose to create a new instance profile, the required role (ecsInstanceRole) is created for you.
9. Leave the **EC2 key pair** field as is, do not provide a key pair.
![AWS Batch](/images/aws-batch/compute-env/batch_compute_environment_configuration.png)
11. Leave the default value of **0** for **Minimum vCPUs**.
12. For **Maximum vCPUs** type **16** (which allows you to use up to 4 instances).
13. Leave the default value of **0** for **Desired vCPUs - *optional***.
14. For **Allowed instance types**, remove **optimal** and choose **g3s.xlarge**.
![AWS Batch](/images/aws-batch/compute-env/batch_instance_configuration_1.png)
15. Select **BEST_FIT** for **Allocation strategy**
16. Expand **Additional settings: launch template, user specified AMI** section.
17. Check **Enable** for **User-specified AMI ID**.
18. Type the **AMI ID** generated with Packer in **Step c. Build Your AMI with Packer**.
![AWS Batch](/images/aws-batch/compute-env/batch_instance_configuration_2.png)
19. Under Networking, for **VPI ID**, choose the Default VPC.
20. Select all the subnets.
21. For **Security groups**, select the default.
22. For **Placement groups - *optional***, leave it empty.
![AWS Batch](/images/aws-batch/compute-env/batch_instance_configuration_3.png)
17. Under **EC2 tags - *optional***, Add a **Tag** called **Name** and for **Value**, type **CARLA Batch** as a name for your instances created with Batch. You can add additional tags if you want.
18. Choose **Create compute environment** to build your new compute environment.
![AWS Batch](/images/aws-batch/compute-env/batch_instance_configuration_4.png)
19. Once the environment is ready, it will be visible under **Compute environments** section. Make sure *Status* is **VALID** and *State* is **ENABLED**.
![AWS Batch](/images/aws-batch/compute-env/batch_environment_ready.png)

At this point, you have done the hard part! Continue to set up a job queue.



