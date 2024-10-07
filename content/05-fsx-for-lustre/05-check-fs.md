+++
title = "e. Examine the File System"
date = 2019-09-18T10:46:30-04:00
weight = 50
tags = ["tutorial", "HSM", "FSx"]
+++

After the cluster is created access the cluster by following steps in [b. Connect to the Cluster](02-connect-cluster.html). Once you've connected run `df -h` to ensure the filesystem is mounted properly:

```bash
$ df -h
Filesystem                   Size  Used Avail Use% Mounted on
devtmpfs                     7.8G     0  7.8G   0% /dev
tmpfs                        7.8G     0  7.8G   0% /dev/shm
tmpfs                        7.8G  820K  7.8G   1% /run
tmpfs                        7.8G     0  7.8G   0% /sys/fs/cgroup
/dev/nvme0n1p1                40G   16G   25G  40% /
172.31.21.102@tcp:/ybajnbmv  1.1T  5.8G  1.1T   1% /shared
tmpfs                        1.6G   16K  1.6G   1% /run/user/42
tmpfs                        1.6G     0  1.6G   0% /run/user/0
```

You'll see a line like `172.31.21.102@tcp:/ybajnbmv  1.1T  5.8G  1.1T   1% /shared` showing the size of the filesystem and the mount point.

Next, use the command `time lfs find /shared` to list all the files present. You should see something similar to:

```bash
$ time lfs find /shared
/shared
/shared/s3dkq4m2.mtx.gz
/shared/SEG_C3NA_Velocity.sgy

real    0m0.001s
user    0m0.001s
sys     0m0.000s
```


Now, look at the size of your files by listing the content of the */shared* directory.

```bash
$ ls -lh /shared
total 1.0K
-rwxr-xr-x 1 root root  13M Jun 22 23:26 s3dkq4m2.mtx.gz
-rwxr-xr-x 1 root root 455M Jun 22 23:26 SEG_C3NA_Velocity.sgy
```

Next, use the command `time lfs df -h` to look at how much data is stored on the Lustre partition for the Metadata Target (MDT) and Object Storage Targets (OSTs).

```bash
$ time lfs df -h
UUID                       bytes        Used   Available Use% Mounted on
unnznbmv-MDT0000_UUID       34.4G        9.1M       34.4G   0% /shared[MDT:0]
unnznbmv-OST0000_UUID        1.1T        7.5M        1.1T   0% /shared[OST:0]

filesystem_summary:         1.1T        7.5M        1.1T   0% /shared


real    0m0.001s
user    0m0.001s
sys     0m0.000s
```

Notice that there is a discrepancy between

- The size of the files **~ 468 MB**
- The data actually stored on the Lustre partition: **~ 7.5 MB** of content and 9.1 MB of metadata.

This discrepancy is due to the lazy loading functionality of Amazon FSx for Lustre when it is linked to an Amazon S3 bucket. Only the metadata of the objects is retrieved on the MDT, the actual bytes or content of the files is copied at first read.
