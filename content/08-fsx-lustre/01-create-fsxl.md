+++
title = "a. Create FSx for Lustre filesystem via FSx Console"
date = 2019-09-18T10:46:30-04:00
weight = 80
tags = ["tutorial", "lustre", "FSx"]
+++

In this section, you will create a new FSx for lustre filesystem in your test account


1. Open the [Amazon FSx console](https://console.aws.amazon.com/fsx/home).

2. Choose  **Create file system** as shown below

![createfilesystem](/images/fsx-for-lustre-hsm/createfilesystem.png)

3. On the next screen select FSx for lustre and click next as shown below.   

![selectfsxforlsutre](/images/fsx-for-lustre-hsm/selectfsxlustre.png)

4. Fill in the details such as filesystem name and file system size in the create file system form as shown below.

![createform](/images/fsx-for-lustre-hsm/createform.png)


{{% notice info %}}
Please leave the cloud9 terminal open in another tab through this  lab.
At times, you will need to go back and forth between the cloud9 terminal and AWS console browser tabs. 
{{% /notice %}}

5. Now go back to the tab where you have the create file system form open and scroll down to the next section to fill in VPC , subnet and security group as shown below. Enter in the VPC field the output of `echo ${VPC_ID}` from the cloud9 terminal, similarly subnet the output of `echo ${SUBNET_ID}`. For the security group from the drop down select the cluster security group (compute) which should look like sg-XXXX (hpc-cluster-lab-ComputeSecurityGroup-XXXX), from the cluster created in the previous lab. This will make sure thefilesystem you create will be in the same network as your cluster as well as any instances that you may need to mount this filesystem on during this lab. Note down/make a mental note of the security group name. This security group will be edited at the end of this section. 

![filesystemnetwork](/images/fsx-for-lustre-hsm/filesystemnetwork.png)

6. Scroll down to the **Backup and Maintanence** section and disable automatic backups as shown below. This step is important because you will be creating a data repository association in section c and to do this we need to make sure automatic backups are disabled.

![disablebackup](/images/fsx-for-lustre-hsm/disablebackup.png) 

7. Choose **Next**.

8. Review the summary and choose  **Create file system**.

![createfsl](/images/fsx-for-lustre-hsm/createfsl.png)

{{% notice info %}}
Amazon FSx for Lustre file system creation will take **approximately 10 mins. In the meantime let us move to next steps**. 
{{% notice info %}}

9. While the file system is creating, you will need to edit the inbound rules of the security group attached to this file system to allow EC2 instances to mount the file system. Open [VPC console] (https://console.aws.amazon.com/vpc/home). On this page, on the left most column you will find a link to **security groups**. Click on this link and look for the security group ( compute cluster security group sg-XXXX (hpc-cluster-lab-ComputeSecurityGroup-XXXX)) you noted in step 6. In the details of this security group click on **Edit inbound rules** button.

![editinbound](/images/fsx-for-lustre-hsm/editinbound.png)

10. This will open a screen where you need to click on **Add rule** button and add **Custom TCP** , port number **988** , from 0.0.0.0. Once this is done, click on **Save rules**.

![988](/images/fsx-for-lustre-hsm/988.png)

