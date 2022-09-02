+++
title = "a. Create FSx for Lustre fielsystem via FSx Console"
date = 2019-09-18T10:46:30-04:00
weight = 80
tags = ["tutorial", "lustre", "FSx"]
+++

In this section, you will create a new FSx for lustre filesystem in your test account


1. On your AWS console main page search for FSx and select and click on FSx service from the drop down. 

2. On the FSx console click on **Create file system** button as shown below

![createfilesystem](/images/fsx-for-lustre-hsm/createfilesystem.png)

3. On the next screen select FSx for lustre and click next as shown below.   

![selectfsxforlsutre](/images/fsx-for-lustre-hsm/selectfsxlustre.png)

3. Fill in the details such as filesystem name and file system size in the create file system form as shown below.

![createform](/images/fsx-for-lustre-hsm/createform.png)

4. For the next section of the form you need to verify your network settings and apply the same on the new file system. For this open another browser tab to go on the AWS console, navigate to cloud9 like in lab1 and open the cloud9 IDE that you have set up previously. 

5. In the cloud9 terminal source the environment variables script in your working directory `env_vars` to set the enviroment and echo the network settings. 

```bash
source env_vars

echo ${AWS_REGION}
echo ${INSTANCES}
echo ${SSH_KEY_NAME}
echo ${VPC_ID}
echo ${SUBNET_ID}

```
6. Now go back to the tab where you have the create file system form open and scroll down to the next section to fill in VPC , subnet and security group as shown below. Here make sure the VPC and subnet you select from the drop down match the enviroment set in your cloud9 terminal and for the security group from the drop down select the cluster security group from the cluster created in the previous lab.. This will make sure thefilesystem you create will be in the same network as your cluster as well as any instances that you may need to mount this filesystem on duringthis lab. 

![filesystemnetwork](/images/fsx-for-lustre-hsm/filesystemnetwork.png)

7. Scroll down to the **Backup and Maintanence** section and disable automatic backups as shown below. This step is important because you will be creating a data repository association in section c and to do this we need to make sure automatic backups are disabled.

![disablebackup](/images/fsx-for-lustre-hsm/disablebackup.png) 

8. Retain the rest of the details in the form at default settings and hit the **Next** button.

9. On the next screen review the settings and at the end of the page as shown below hit the **Create file system** button.

![createfsl](/images/fsx-for-lustre-hsm/createfsl.png)

10. Creating this file system is expected to take around 10 mins. In the meantime let us move to next steps. 

