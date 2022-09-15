+++
title = "d. Launch an EC2 instance to mount the filesystem"
date = 2019-09-18T10:46:30-04:00
weight = 80
tags = ["tutorial", "lustre", "FSx", "S3"]
+++

In this section you will launch an Amazon EC2 instance which will be used in the next section to mount the filesystem created in section a.

1. Navigate to the [Amazon EC2 Console](https://console.aws.amazon.com/ec2/home) to navigate to your EC2 dashboard on AWS console.. 

2. Choose  **Launch instance**.

![ec2launch](/images/fsx-for-lustre-hsm/ec2launch.png)

3. On "Choose AMI ( Amazon Machine Image ) page select Amazon linux 2.

![selectami](/images/fsx-for-lustre-hsm/selectami.png)

4. Scroll down on the "Choose an Instance type" page to select **c5n.18xlarge** instance and click on **Next:Configure Instance Details** button as shown below..

![selectic5n](/images/fsx-for-lustre-hsm/selectc5n.png)

5. On the "Configure Instance Details" page, make sure the VPC ID and the subnet ID you enter are identical to the ones you used while building FSx for lustre filesystem in section a. To remind you of these details, you can go on your cloud9 IDE and run the following commands. Also make sure you select **enable** for **Auto assign public IP** field in this form. Retain the rest of the fields with default values and click on **Review and Launch** button.

```bash
source env_vars

echo ${AWS_REGION}
echo ${SSH_KEY_NAME}
echo ${VPC_ID}
echo ${SUBNET_ID}
```

![ec2networklaunch](/images/fsx-for-lustre-hsm/ec2networklaunch.png)

6. On the next page click **Launch**. 

![ec2finallaunch](/images/fsx-for-lustre-hsm/ec2finallaunch.png)

7. This will open a pop-up where you will need to select an ssh key pair to access this instance. In the drop down you will be able to see the key-pair you created in lab 1. Select this key pair and click on **Launch Instances**

![keypair](/images/fsx-for-lustre-hsm/keypair.png)

8. It will take a couple minutes for the instance to be configured. You can click on the link to the instance ID as shown below. 

![launchmsg](/images/fsx-for-lustre-hsm/launchmsg.png)

10. This will show you the instance you launched just now on the EC2 instances dashboard and wait for the status to be **Running** as shown below.

![ec2status](/images/fsx-for-lustre-hsm/ec2status.png)
