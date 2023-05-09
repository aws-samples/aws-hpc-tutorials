+++
title = "e. Examine the File System"
date = 2019-09-18T10:46:30-04:00
weight = 50
tags = ["tutorial", "HSM", "FSx"]
+++

After the cluster is created access the cluster by following steps in [a. Create HPC Cluster](01-create-cluster.html) and [b. Create FSx Lustre](02-create-cluster-fsx.html). Connect by selecting the cluster using AWS ParallelCluster UI, wait for a few seconds, and then use the **Shell** button on the top of the page. Once you've connected run
```bash
sudo su - ec2-user
```
to get the familiar user and environment.

Enter
```bash
df -h
```
to ensure the filesystem is mounted at `/shared`:

```bash
Filesystem                   Size  Used Avail Use% Mounted on
devtmpfs                     7.6G     0  7.6G   0% /dev
tmpfs                        7.6G     0  7.6G   0% /dev/shm
tmpfs                        7.6G  584K  7.6G   1% /run
tmpfs                        7.6G     0  7.6G   0% /sys/fs/cgroup
/dev/nvme0n1p1                40G   16G   25G  39% /
172.31.21.145@tcp:/2hwmvbmv  1.2T  7.5M  1.2T   1% /shared
tmpfs                        1.6G     0  1.6G   0% /run/user/1000
tmpfs                        1.6G     0  1.6G   0% /run/user/0
```

You'll see a line like `172.31.21.145@tcp:/2hwmvbmv  1.2T  7.5M  1.2T   1% /shared` showing the size of the filesystem and the mount point.

Next, use the command `time lfs find /shared` to list all the files present. You should see something similar to:

```bash
lfs find /shared
```
```bash
/shared
/shared/s3dkq4m2.mtx.gz
/shared/SEG_C3NA_Velocity.sgy
```

If the file system is empty you might have to wait for the DRA and data reposition import task to reach the state **Available**.
Now, look at the size of your files by listing the content of the */shared* directory.

```bash
$ ls -lh /shared
total 1.0K
-rwxr-xr-x 1 root root  13M Jun 22 23:26 s3dkq4m2.mtx.gz
-rwxr-xr-x 1 root root 455M Jun 22 23:26 SEG_C3NA_Velocity.sgy
```

Next, use the command `lfs df -h` to look at how much data is stored on the Lustre partition for the Metadata Target (MDT) and Object Storage Targets (OSTs).

```bash
$ lfs df -h
```
```bash
UUID                       bytes        Used   Available Use% Mounted on
2hwmvbmv-MDT0000_UUID       34.4G        9.8M       34.4G   0% /shared[MDT:0]
2hwmvbmv-OST0000_UUID        1.1T        7.5M        1.1T   0% /shared[OST:0]

filesystem_summary:         1.1T        7.5M        1.1T   0% /shared

```

Notice that there is a discrepancy between

- The size of the files **~ 455 MiB**
- The data actually stored on the Lustre partition: **~ 7.5 MiB** of content and 9.1 MiB of metadata.

This discrepancy is due to the lazy loading functionality of Amazon FSx for Lustre when it is linked to an Amazon S3 bucket. Only the metadata of the objects is retrieved on the MDT, the actual bytes or content of the files is copied at first read.
