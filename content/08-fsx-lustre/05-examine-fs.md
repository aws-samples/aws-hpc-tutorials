+++
title = "e. Monitor the Filesystem and check auto import and lazy loading"
date = 2019-09-18T10:46:30-04:00
weight = 120
tags = ["tutorial", "lustre", "FSx", "S3"]
+++

In this section you will log in to the updated cluster, launch a job and check the mounted lustre filesystem. You will check the contents of the file system and data repository in S3. This will help understand the HSM capabilities and feature of FSx for Lustre.

1. Go to your cloud9 terminal and run the following command to retrive the name of the SSH Key you created in lab1.

```bash
source env_vars

echo ${SSH_KEY_NAME}
```

2. Log in to the cluster

```bash
pcluster ssh -n hpc-cluster-lab --region ${AWS_REGION} -i ~/.ssh/${SSH_KEY_NAME}
```

Continue connecting to the head node of the cluster by saying **yes**


3. The Lustre Filesystem is mounted only on the Compute Nodes. Submit a Slurm job to allocate a compute node

```bash
srun -N 1 --exclusive --pty /bin/bash -il
```
It will take around 5 mins to get your compute node. 

4. Confirm that the lustre filesystem is mounted on the compute node and is available.

```bash
df -h /fsx
```

5. You have now successfully mounted the file system. The next step is to verify the data respository association and run some HSM commands. Go into the fsx for lustre directory and into the data repository path to verify the files uploaded into s3 bucket in section b are seen on the file system. --> This verifies **auto import** from S3 to FSx for lustre. You should see the test data **SEG_C3NA_Velocity.sgy** you uploaded in the S3 bucket on the FSx Lustre filesystem.

```bash
cd /fsx/hsmtest
ls -lrt
```

6. **Lazy Loading** FSx for lustre uses the lazy load  policy where the meta data is visible when you look at the data repository path, however the data is copied to the filesystem only at the time of first access and subsequent accesses will be faster. You can see this by running the command `lfs df -h`. We know that the actual size of the file uploaded into S3 is 455MB. However the space used on the file system before access is 7.8MB of metadata.
You can also run `lfs hsm_state /fsx/hsmtest/SEG_C3NA_Velocity.sgy`. It confirms that the file is released but is archived.

![lazyload](/images/fsx-for-lustre-hsm/lazyload.png)

You should see that the file is **released**, i.e. not loaded.

7. Now, check the size of the file

```bash
 ls -lah /fsx/hsmtest/SEG_C3NA_Velocity.sgy
```

![lazyloadsize](/images/fsx-for-lustre-hsm/lazyloadsize.png)

As shown above, the file size is about 455 MB.


8. Next you will access the file and measure the time it takes to load it from the linked Amazon S3 bucket using the HSM. You write the file to *tempfs*.

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

![lazyloadaccess](/images/fsx-for-lustre-hsm/lazyloadaccess.png)

#### Review the File System Status

9. Next, look at the file content state through the HSM. Run the following command

```bash
lfs hsm_state /fsx/hsmtest/SEG_C3NA_Velocity.sgy
```

You can see that the file state changed from **released** to **archived**.

Now, use the following command to see how much data is stored on the Lustre partition.

```bash
time lfs df -h
```

Do you notice a difference compared to the previous execution of this command? Instead of **7.8 MB** of data stored, you now have **465 MB** stored on the OST, your may see slightly different results.

![lazyloadarchived](/images/fsx-for-lustre-hsm/lazyloadarchived.png)


10. Next you will release the file Content. This action does not not delete nor remove the file itself. The metadata is still stored on the MDT.

Use the following command to release the file content:

```bash
sudo lfs hsm_release /fsx/hsmtest/SEG_C3NA_Velocity.sgy
```

Then, run this command to see again how much data is stored on your file system.

```bash
lfs df -h
```

You are back to **7.8 MB** of stored data.

![lazyloadreleased](/images/fsx-for-lustre-hsm/lazyloadreleased.png)

Access the file again and check how much time it takes.

```bash
time cat /fsx/hsmtest/SEG_C3NA_Velocity.sgy > /dev/shm/fsx
```

It should take around 5-6 seconds like we checked in step 11. Subsequent reads use the client cache. You can drop the caches, if desired.

In the next section you will test auto export feature of the FSx-S3 data repository association.
