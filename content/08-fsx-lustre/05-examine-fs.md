+++
title = "e. Mount the lustre file system and check data repository"
date = 2019-09-18T10:46:30-04:00
weight = 80
tags = ["tutorial", "lustre", "FSx", "S3"]
+++

In this section you will log in to the EC2 instance launched in section d and then mount the lustre file system you created in section a. You will then also check the contents of the file system and data repository in S3. This will help understand the HSM capabilities and feature of FSx for Lustre. 

1. Go to your cloud9 terminal and now login and run the following command to retrive the name of the SSH Key you created in lab1.

```bash
source env_vars

echo ${SSH_KEY_NAME}
```

2. Now to log in to the EC2 instance go to the instance dashboard browser tab from the previous section and click on the instance you created. 

![clickinstance](/images/fsx-for-lustre-hsm/clickinstance.png)

3. This will show you the instance details and copy the public IP from the details. 

![copyip](/images/fsx-for-lustre-hsm/copyip.png)

4. Go back to your cloud9 terminal and type the following command and paste the IP you copied into the IP in the command below to ssh into the instance.
The AMI you selected will configure the instance with **ec2-user** as the user and please use this username to login to the instance

```bash
ssh ec2-user@paste-public-ip -i $SSH_KEY_NAME
```

![ec2login](/images/fsx-for-lustre-hsm/ec2login.png)

5. Prepare the instance to mount the lustre file system by installing the lustre client by running the command below  

```bash
sudo yum install -y lustre-client
```

6. Click [here](https://console.aws.amazon.com/fsx/home) to navigate to FSx service. Click on **sc22lab2** lustre file system you created in section a. Here you need to copy the details for the mount. The mount point name as well as the file system DNS name as shown below. Have these details handy to paste them in the command in the next step.

![fsxdns](/images/fsx-for-lustre-hsm/fsxdns.png)

7. Now, back on the cloud9 terminal, which is logged into the EC2 instance type the following commands to create a mount directory for FSx for lustre file system on the instance as well as the mount command to mount the file system. Please make sure you paste the mount name and file system dns name in the mount command below. Please note, the file system DNS name will look like **fsxlustreid.fsx.region.amazonaws.com**. Make sure to use the copy button next to the DNS name in the screenshot above to copy the whole DNS name.

```bash
sudo mkdir /fsx
sudo mount -t lustre -o noatime,flock filesystemdns@tcp:/mountname /fsx 
df -h
```

![fsxmount](/images/fsx-for-lustre-hsm/fsxmount.png)

8. You have now successfully mounted the file system. The next step is to verify the data respository association and run some HSM commands. Go into the fsx for lustre directory and into the data repository path to verify the files uploaded into s3 bucket in section b are seen on the file system. --> This verifies **auto import** from S3 to FSx for lustre. 

![import](/images/fsx-for-lustre-hsm/import.png)

9. **Lazy Loading** FSx for lustre uses the lazy load  policy where the meta data is visible when you look at the data repository path, however the data is copied to the filesystem only at the time of first access and subsequent accesses will be faster. You can see this by running the command `lfs df -h`. We know that the actual size of the file uploaded into S3 is 455MB. However the space used on the file system before access is 7.8MB of metadata. 
You can also run `lfs hsm_state /fsx/hsmtest/SEG_C3NA_Velocity.sgy`. It confirms that the file is released but is archived. 

![lazyload](/images/fsx-for-lustre-hsm/lazyload.png)

10. You will next test **auto export**. When we created the data repository association we chose to go with automatic export from FSx file system to the S3 bucket. To test this, let us just create a 10MB file on the file system and then verify on the S3 bucket.

```bash
sudo chown -R ec2-user /fsx/
cd /fsx/hsmtest
truncate -s 10M export_test_file
ls -lh
```

11. Now go back on the AWS console page, search for S3 service, click on the bucket you created in section b. Here you should be seeing the newly created file **export_test_file** of 10M automatically copied into S3 bucket. This verifies the auto export of this data repository association. 

![exportfile](/images/fsx-for-lustre-hsm/exportfile.png)


![verifys3export](/images/fsx-for-lustre-hsm/verifys3export.png)

