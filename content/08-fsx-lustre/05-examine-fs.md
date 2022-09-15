+++
title = "e. Mount the lustre file system and check auto import and lazy loading"
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

You should see that the file is **released**, i.e. not loaded.

10. Now, check the size of the file 

```bash
$ ls -lah /fsx/hsmtest/SEG_C3NA_Velocity.sgy
```
![lazyloadsize](/images/fsx-for-lustre-hsm/lzyloadsize.png)

As shown above, the file size is about 455 MB.


11. Next you will access the file and measure the time it takes to load it from the linked Amazon S3 bucket using the HSM. You write the file to *tempfs*.

Use the following command to retrive the file

```bash
time cat /fsx/hsmtest/SEG_C3NA_Velocity.sgy > /dev/shm/fsx
```

It should take  about **6 seconds** to retrieve the file.

Run the command again and see the access time:

```bash
time cat /fsx/hsmtest/SEG_C3NA_Velocity.sgy > /dev/shm/fsx
```

This time it should take lesser about  **.2 seconds** only.

The new access time is a bit too fast because the data has been cached on the instance. Now, drop the caches and repeat the command again.

```bash
sudo bash -c 'echo 3 > /proc/sys/vm/drop_caches'
time cat /fsx/hsmtest/SEG_C3NA_Velocity.sgy > /dev/shm/fsx
```

This access time is more realistic: at about **0.9s**

![lazyloadaccess](/images/fsx-for-lustre-hsm/lzyloadaccess.png)

#### Review the File System Status

12. Next, look at the file content state through the HSM. Run the following command 

```bash
lfs hsm_state /fsx/hsmtest/SEG_C3NA_Velocity.sgy
```
You can see that the file state changed from **released** to **archived**.

Now, use the following command to see how much data is stored on the Lustre partition.

```bash
time lfs df -h
```

Do you notice a difference compared to the previous execution of this command? Instead of **7.8 MB** of data stored, you now have **465 MB** stored on the OST, your may see slightly different results.

![lazyloadarchived](/images/fsx-for-lustre-hsm/lzyloadarchived.png)


13. Next you will release the file Content. This action does not not delete nor remove the file itself. The metadata is still stored on the MDT.

Use the following command to release the file content:

```bash
sudo lfs hsm_release /fsx/hsmtest/SEG_C3NA_Velocity.sgy
```

Then, run this command to see again how much data is stored on your file system.

```bash
lfs df -h
```

You are back to **7.8 MB** of stored data.

![lazyloadreleased](/images/fsx-for-lustre-hsm/lzyloadreleased.png)

Access the file again and check how much time it takes.

```bash
time cat /fsx/hsmtestSEG_C3NA_Velocity.sgy >/dev/shm/fsx
```

It should take around 5-6 seconds like we checked in step 11. Subsequent reads use the client cache. You can drop the caches, if desired.

In the next section you will test auto export feature of the FSx-S3 data repository association.
