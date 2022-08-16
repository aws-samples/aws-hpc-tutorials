+++
title = "f. About Lazy File Loading"
date = 2019-09-18T10:46:30-04:00
weight = 60
tags = ["tutorial", "HSM", "FSx", "Laxy Load"]
+++

{{% notice note %}}
This section reuses content from the [Amazon FSx for Lustre Lazy Load Workshop](https://github.com/aws-samples/amazon-fsx-workshop/tree/master/lustre/03-load-data). If you want to dive deeper into lazy file loading, check out the workshop.
{{% /notice %}}

As you saw in the previous section, the file content is not yet retrieved on the file system. However, nothing prevents you from accessing your files as you would on any other POSIX compliant file system. When accessing the file, the actual content is retrieved. The file access latency is slightly higher for the first access, but once the content has been retrieved, file access latency drops to a [sub-millisecond latency](https://docs.aws.amazon.com/fsx/latest/LustreGuide/performance.html#storage-layout) because it is served by the file system on subsequent accesses. In addition, releasing a file from the file system does not delete the file but removes its actual content. The metadata is still be stored on the file system.

In this section, you learn more about the lazy loading functionality, observe the performances between consecutive accesses, then learn about file content removal.

#### Check the File State

First, use command `time lfs hsm_state /shared/SEG_C3NA_Velocity.sgy` to check that the file data is not loaded on Lustre:

```bash
$ time lfs hsm_state /shared/SEG_C3NA_Velocity.sgy
/shared/SEG_C3NA_Velocity.sgy: (0x0000000d) released exists archived, archive_id:1

real    0m0.002s
user    0m0.001s
sys     0m0.000s
```

You should see that the file is **released**, i.e. not loaded.

Now, check the size of the file with `time ls -lah /shared/SEG_C3NA_Velocity.sgy`:

```bash
$ time ls -lah /shared/SEG_C3NA_Velocity.sgy
-rwxr-xr-x 1 root root 455M Jun 22 23:26 /shared/SEG_C3NA_Velocity.sgy

real    0m0.002s
user    0m0.001s
sys     0m0.000s
```

As shown above, the file size is about 455 MB.


#### Retrieve the File Content

For this step, you read the file and measure the time it takes to load it from the linked Amazon S3 bucket using the HSM. You write the file to *tempfs*.

Use the following command to retrieve the file:

```bash
$ time cat /shared/SEG_C3NA_Velocity.sgy > /dev/shm/fsx

real    0m6.701s
user    0m0.000s
sys     0m0.294s
```

It took about **6 seconds** to retrieve the file.

Run the command again and see the access time:

```bash
time cat /shared/SEG_C3NA_Velocity.sgy > /dev/shm/fsx

real    0m0.169s
user    0m0.000s
sys     0m0.168s
```

This time it took only **.16 seconds**.

The new access time is a bit too fast because the data has been cached on the instance. Now, drop the caches and repeat the command again.

```bash
sudo bash -c 'echo 3 > /proc/sys/vm/drop_caches'
time cat /lustre/SEG_C3NA_Velocity.sgy > /dev/shm/fsx
```

This access time is more realistic:

```
real    0m0.591s
user    0m0.005s
sys     0m0.312s
```

#### Review the File System Status

Next, look at the file content state through the HSM.

Run the command `time lfs hsm_state /shared/SEG_C3NA_Velocity.sgy`:

```bash
$ time lfs hsm_state /shared/SEG_C3NA_Velocity.sgy
/shared/SEG_C3NA_Velocity.sgy: (0x00000009) exists archived, archive_id:1

real    0m0.006s
user    0m0.001s
sys     0m0.000s
```

You can see that the file state changed from **released** to **archived**.

Now, use the following command to see how much data is stored on the Lustre partition.

```bash
$ time lfs df -h
UUID                       bytes        Used   Available Use% Mounted on
unnznbmv-MDT0000_UUID       34.4G        9.2M       34.4G   0% /shared[MDT:0]
unnznbmv-OST0000_UUID        1.1T      471.5M        1.1T   0% /shared[OST:0]

filesystem_summary:         1.1T      471.5M        1.1T   0% /shared


real    0m0.002s
user    0m0.001s
sys     0m0.000s
```

Do you notice a difference compared to the previous execution of this command? Instead of **7.5 MB** of data stored, you now have **471.5 MB**. In this case, it is stored on the second OST, your may see slightly different results.

#### Release the File Content

In this step, you release the file content. This action does not not delete nor remove the file itself. The metadata is still stored on the MDT.

Use the following command to release the file content:

```bash
time sudo lfs hsm_release /shared/SEG_C3NA_Velocity.sgy
```

Then, run this command to see again how much data is stored on your file system.

```bash
$ time lfs df -h
UUID                       bytes        Used   Available Use% Mounted on
unnznbmv-MDT0000_UUID       34.4G        9.2M       34.4G   0% /shared[MDT:0]
unnznbmv-OST0000_UUID        1.1T        7.5M        1.1T   0% /shared[OST:0]

filesystem_summary:         1.1T        7.5M        1.1T   0% /shared


real    0m0.001s
user    0m0.001s
sys     0m0.000s
```

You are back to **7.5 MB** of stored data.

Access the file again and check how much time it takes.

```bash
time cat /lustre/SEG_C3NA_Velocity.sgy >/dev/shm/fsx
```

It should take around 6 seconds. Subsequent reads use the client cache. You can drop the caches, if desired.

```bash
[ec2-user@ip-172-31-24-231 ~]$ time cat /shared/SEG_C3NA_Velocity.sgy >/dev/shm/fsx

real    0m5.819s
user    0m0.000s
sys     0m0.327s
[ec2-user@ip-172-31-24-231 ~]$ time cat /shared/SEG_C3NA_Velocity.sgy >/dev/shm/fsx

real    0m0.203s
user    0m0.000s
sys     0m0.202s
[ec2-user@ip-172-31-24-231 ~]$ sudo bash -c 'echo 3 > /proc/sys/vm/drop_caches'
[ec2-user@ip-172-31-24-231 ~]$ time cat /shared/SEG_C3NA_Velocity.sgy >/dev/shm/fsx

real    0m0.618s
user    0m0.000s
sys     0m0.351s
```

In the next step, you install IOR, an IO parallel benchmark tool used to complete performance tests on your Lustre partition.
