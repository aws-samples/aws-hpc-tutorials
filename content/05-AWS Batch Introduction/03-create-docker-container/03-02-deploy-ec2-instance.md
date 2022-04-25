+++
title = "1.a. Deploy an Amazon EC2 instance"
date = 2019-09-18T10:46:30-04:00
weight = 42
tags = ["tutorial", "install", "AWS", "batch", "Docker", "ECR"]
+++

You will create an instance to build a container and push it to Amazon ECR. To do so, you will:

1. Create an Amazon EC2 Instance
2. Assign an Amazon IAM role to grant your instance the right to push containers to Amazon ECR.
3. Connect to your instance.


### Deploy an Amazon EC2 instance
1. **Open** the Amazon EC2 console ([link](https://console.aws.amazon.com/ec2/v2/)) to find your Amazon EC2 instances.
![EC2 instance create](/images/aws-batch/deep-dive/Instances___EC2_Management_Console.png)
2. **Click** on *Launch Instances* in the upper right hand corner. ![EC2 instance create](/images/aws-batch/deep-dive/Instances___EC2_Management_Console-2.png)
3. **Type** the name of your instance. Here you can see the instance name is *DockerBuilder*. Please use whatever you see fit. ![EC2 instance create](/images/aws-batch/deep-dive/Launch_an_instance___EC2_Management_Console.png)
4. **Keep** the Amazon Machine Image and Instance type at the default values.  These should be free eir eligable.  ![EC2 instance create](/images/aws-batch/deep-dive/Cursor_and_Launch_an_instance___EC2_Management_Console.png)
5. **Create** a new key pair to be able to connect to your new instance.![EC2 instance create](/images/aws-batch/deep-dive/EC2_KP1.png) 
6. **Type** the name of your key pair. Here you can see the instance name is *dockerKP*. Please use whatever you see fit. ![EC2 instance create](/images/aws-batch/deep-dive/EC2_KP2.png) 
7. **Click** on *Create key pair.* ![EC2 instance create](/images/aws-batch/deep-dive/EC2_KP3.png) 
8. **Note** that the key pair has been downloaded to your computer. ![EC2 instance create](/images/aws-batch/deep-dive/EC2_KP4.png) 
9. **Click** on *Edit* in Network Settings to make sure the EC2 instance is in the correct VPC. ![EC2 instance create](/images/aws-batch/deep-dive/EC2_Management_Console.png) 
10. **Select** the VPC you created in the first template in the VPC box.![EC2 instance create](/images/aws-batch/deep-dive/EC2_Management_Console-2.png) 
11. **Select** the public subnet you created in the first template in the subnet box.![EC2 instance create](/images/aws-batch/deep-dive/EC2_Management_Console-3.png) 
12. **Choose** *Create security group* under the firewall option.  ![EC2 instance create](/images/aws-batch/deep-dive/EC2_Management_Console-4.png) 
13. **Leave** all other sections in Network settings with the *default* values.
14. **Review** the *Summary* box before you launch.![EC2 instance create](/images/aws-batch/deep-dive/EC2_Management_Console-5.png) 
15. **Click** *Launch instance* to launch your instance![EC2 instance create](/images/aws-batch/deep-dive/EC2_Management_Console-6.png) 
16. **Note** the successful launch of the instance and click *View all instances* ![EC2 instance create](/images/aws-batch/deep-dive/EC2_Management_Console-7.png) 

### Add instance role
1. **Check** that the instance you just created is running. **Check** the checkbox next to that instace. **Drop** the *Action* menu. ![EC2 instance create](/images/aws-batch/deep-dive/EC2_Management_Console-8.png)
2. **Select** *Security* from the menu options. ![EC2 instance create](/images/aws-batch/deep-dive/Instances___EC2_Management_Console-3.png)
3. **Select** *Modify IAM role* under the security options. Your instance needs to have the policy `AmazonEC2ContainerRegistryPowerUser` attached to its [IAM role](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/iam-roles-for-amazon-ec2.html)![EC2 instance create](/images/aws-batch/deep-dive/Instances___EC2_Management_Console-4.png)
4. **Click** *Create new IAM role*. This will send you to the IAM Roles page.  ![EC2 instance create](/images/aws-batch/deep-dive/Modify_IAM_role___EC2_Management_Console.png)
5. **Select** *Create role*. ![EC2 instance create](/images/aws-batch/deep-dive/IAM_Management_Console.png)
6. **Choose** the Trusted entity type to the AWS service and **choose** the common use cases to be *EC2*. **Click** *Next* on the bottom right hand corner.![EC2 instance create](/images/aws-batch/deep-dive/IAM_Management_Console-2.png)
7. **Type** `AmazonEC2ContainerRegistryPowerUser` into the search bar. **Hit** enter. ![EC2 instance create](/images/aws-batch/deep-dive/IAM_Management_Console-3.png)
8. **Check** the box next to `AmazonEC2ContainerRegistryPowerUser`. **Click** *Next*. ![EC2 instance create](/images/aws-batch/deep-dive/IAM_Management_Console-4.png)
9.  **Type** the name of your new role. Here you can see the Role name is *DockerBuilderRole*. Please use whatever you see fit.![EC2 instance create](/images/aws-batch/deep-dive/IAM_Management_Console-5.png)
10.  **Leave** all other sections with the *default* values. **Click** *Create role* on the bottom right hand side of the page.![EC2 instance create](/images/aws-batch/deep-dive/IAM_Management_Console-6.png)
11. **Open** the Amazon EC2 console again ([link](https://console.aws.amazon.com/ec2/v2/)) to find your Amazon EC2 instances now that you have created the role . ![EC2 instance create](/images/aws-batch/deep-dive/EC2_Management_Console-8.png)
2. **Select** *Security* from the menu options. ![EC2 instance create](/images/aws-batch/deep-dive/Instances___EC2_Management_Console-3.png)
3. **Select** *Modify IAM role* under the security options. Now we will add the policy we have just created to the instance. [EC2 instance create](/images/aws-batch/deep-dive/Instances___EC2_Management_Console-4.png)
4. **Select** the new IAM role from the drop down menu. **Click** *Save*.  ![EC2 instance create](/images/aws-batch/deep-dive/Modify_IAM_role___EC2_Management_Console-2.png)

### Connect to your instance
1. **Check** that the instance you just created is running. **Check** the checkbox next to that instace. **Drop** the *Action* menu. ![EC2 instance create](/images/aws-batch/deep-dive/EC2_Management_Console-8.png)
2. **Select** *Connect* from the menu options. ![EC2 instance create](/images/aws-batch/deep-dive/EC2_Management_Console-9.png) 
3. **Connect** to your instance. There are multiple ways to connect to your instance.  **Select** your preffered way and follow the directions on the screen. Here, the workshop will use the terminal window to connect using the *key pair* we created in the above step. ![EC2 instance create](/images/aws-batch/deep-dive/Connect_to_instance___EC2_Management_Console.png)
![EC2 instance create](/images/aws-batch/deep-dive/terminal_1.png)
