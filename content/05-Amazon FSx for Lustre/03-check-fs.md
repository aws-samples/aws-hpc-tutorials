+++
title = "c. Examine the File System"
date = 2019-09-18T10:46:30-04:00
weight = 40
tags = ["tutorial", "HSM", "FSx"]
+++

In this section, you learn about the file system, it's structure and content.

First, use the following command to list all the files present.

```bash
time lfs find /lustre
```

You should see something similar as in the image below.

![lfs find](/images/fsx-for-lustre/lfs-find.png)


Now, look at the size of your files by listing the content of the */lustre* directory.

```bash
ls -lh /lustre
```
You should see something like the following image:

![Lustre ls -lh](/images/fsx-for-lustre/ls-lh.png)

Next, use the following command to look at how much data is stored on the Lustre partition for the Metadata Target (MDT) and Object Storage Targets (OSTs).

```bash
time lfs df -h
```
The result should be comparable to the one shown below.

![Lustre ls -dh](/images/fsx-for-lustre/lfs-dh.png)

Notice that there is a discrepancy between

- The size of the files **~ 468 MB**
- The data actually stored on the Lustre partition: **~ 13.5 MB** of content and 5.8 MB of metadata.

This discrepancy is due to the lazy loading functionality of Amazon FSx for Lustre when it is linked to an Amazon S3 bucket. Only the metadata of the objects is retrieved on the MDT, the actual bytes or content of the files is copied at first read.
