+++
title = "1. Deploy an Amazon EC2 instance"
date = 2019-09-18T10:46:30-04:00
weight = 42
tags = ["tutorial", "install", "AWS", "batch", "Docker", "ECR"]
+++

{{% notice info %}}
If you are using the Cloud9 environment that you created in the [Getting Started in the Cloud](/02-aws-getting-started.html), please continue to the next section. Otherwise, please continue below.
{{% /notice %}}

In this section, you will spin up an Amazon instance that you will use to build a container, push it to Amazon ECR and submit your jobs to AWS Batch. To do so, you will:

1. Deploy an Amazon EC2 instance
2. Assign an Amazon IAM role to grant your instance the right to push containers to Amazon ECR.
3. Connect to your instance.


#### To deploy an Amazon EC2 instance

1. Open the Amazon EC2 console. ([link](https://console.aws.amazon.com/ec2/v2/)) 
2. Choose **Launch Instances** 
3. For **Name**, enter `DockerBuilder`. 
4. In the *Amazon Machine Image and Instance type* section, leave the default values. These should be free teir eligable.  
5. In the *Key pair (login)* section, do the following:

	a. Choose **Create new key pair**. These steps will allow you to connect to your new instance.

	b. For **Key pair name**, enter `dockerKP`. 

	c. Leave **Key pair type** and **Private key file format** at their default values.

	d. Choose **Create key pair**. The key pair will be downloaded to your computer. ![EC2 instance create](/images/aws-batch/deep-dive/EC2_KP3.png) 

6. In *Network settings* section, clear **Allow SSH traffic from**.

7. Leave the rest of the settings at their default values. 

8. Review the **Summary** box.![EC2 instance create](/images/aws-batch/deep-dive/EC2_Management_Console-11.png) 

9. Choose **Launch instance**. 

The EC2 instance will now be launched for use. Note the successful launch of the instance and choose **View all instances**  

Now that you have launched the instance, you will assign the instance a role to you will allow your instance to push images to Amazon ECR. Roles contain [policies](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html) that define what you, users and resources are permitted to do on an AWS account. 


#### To add instance role

1. Verify the instance you just created is running. 
2. Select the `DockerBuilder` instance. 
3. On the **Action** menu, choose **Security**, submenu **Modify IAM role**. ![EC2 instance create](/images/aws-batch/deep-dive/Instances___EC2_Management_Console-4.png). 
4. In the *IAM Roles page*, do the following:

	a. Choose **Create role**. 

	b. Choose **Trusted entity type** as *AWS service*.

	c. Choose the **Common use cases** as *EC2*.

	d. Choose **Next**.

	e. In the *search bar*, enter `AmazonEC2ContainerRegistryPowerUser` ([IAM role](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/iam-roles-for-amazon-ec2.html))

	f. Select `AmazonEC2ContainerRegistryPowerUser`.

	g. Choose **Clear filters**.

	h. In the *search bar*, enter `AmazonSSMManagedInstanceCore`.

	i. Select `AmazonSSMManagedInstanceCore`. You should now have selected 2 *Permissions policies*.

	j. Choose **Next**.

	k. For **Role name**, enter `DockerBuilderRole`. 

	l. Leave the remaining sections with the *default* values. 

	m. Choose **Create role**. ![EC2 instance create](/images/aws-batch/deep-dive/IAM_Management_Console-6.png)

5. Open the Amazon EC2 console. ([link](https://console.aws.amazon.com/ec2/v2/))  
6. Select the `DockerBuilder` instance. 
7. On the **Action** menu, choose **Security**, submenu **Modify IAM role**.
8. For **IAM role**, choose the `DockerBuilderRole` you just created. 
9. Choose **Save**.  ![EC2 instance create](/images/aws-batch/deep-dive/Modify_IAM_role___EC2_Management_Console-2.png)

You now added the role you needed to your EC2 instance.  Now we are going to connect to the instance.

#### To connect to your instance

You now connect to the instance and will proceed to the next steps.

1. Verify the instance you just created is running. 
2. Select the `DockerBuilder` instance. 
4. On the **Action** menu, choose **Connect**. 
3. Connect to your instance. There are multiple ways to connect to your instance.  This workshop will use Session Manager to connect to the EC2 instance securely. You may need to wait a few minutes for the option to connect to become available. ![EC2 instance create](/images/aws-batch/deep-dive/Connect_to_instance___EC2_Management_Console.png)


You have now:
- Deployed an Amazon EC2 instance
- Assigned an Amazon IAM role to grant your instance the right to push containers to Amazon ECR.
- Connected to your instance.

#### Next Steps
Next you will install Docker onto this instance.
