+++
title = "d. About Lazy File Loading"
date = 2019-09-18T10:46:30-04:00
weight = 50
tags = ["tutorial", "HSM", "FSx", "Laxy Load"]
+++

{{% notice note %}}
This section reuses content from the [Amazon FSx for Lustre Lazy Load Workshop](https://github.com/aws-samples/amazon-fsx-workshop/tree/master/lustre/03-load-data). If you want to dive deeper into lazy file loading, check out the workshop.
{{% /notice %}}

As you saw in the previous section, the file content is not yet retrieved on the file system. However, nothing prevents you from accessing your files as you would on any other POSIX compliant file system. When accessing the file, the actual content is retrieved. The file access latency is slightly higher for the first access, but once the content has been retrieved, file access latency drops to a [sub-millisecond latency](https://docs.aws.amazon.com/fsx/latest/LustreGuide/performance.html#storage-layout) because it is served by the file system on subsequent accesses. In addition, releasing a file from the file system does not delete the file but removes its actual content. The metadata is still be stored on the file system.

In this section, you learn more about the lazy loading functionality, observe the performances between consecutive accesses, then learn about file content removal.

#### Check the File State

First, use the following command to check that the file data is not loaded on Lustre.

```bash
time lfs hsm_state /lustre/SEG_C3NA_Velocity.sgy
```

You should see that the file is **released**, i.e. not loaded. Similar result as shown below:

![Lustre file state](/images/fsx-for-lustre/lfs-state.png)


Now, check the size of the file.

```bash
time ls -lah /lustre/SEG_C3NA_Velocity.sgy
```

As shown here, the file size is about 455 MB.

![Lustre ls lah](/images/fsx-for-lustre/ls-lha.png)


#### Retrieve the File Content

For this step, you read the file and measure the time it takes to load it from the linked Amazon S3 bucket using the HSM. You write the file to *tempfs*.

Use the following command to retrieve the file:

```bash
time cat /lustre/SEG_C3NA_Velocity.sgy > /dev/shm/fsx
```

It took about 5 seconds to perform the initial retrieve of the file. If you run the command again, you'll see this time drops down to .23 seconds:

```bash
time cat /lustre/SEG_C3NA_Velocity.sgy > /dev/shm/fsx
```

![Lustre ls lah](/images/fsx-for-lustre/cat-file.png)

The new access time is a bit too fast because the data has been cached on the instance. Now, drop the caches and repeat the command again.

```bash
sudo bash -c 'echo 3 > /proc/sys/vm/drop_caches'
time cat /lustre/SEG_C3NA_Velocity.sgy > /dev/shm/fsx
```

This access time is more realistic.

![Lustre drop caches](/images/fsx-for-lustre/cat-file3.png)


#### Review the File System Status

Next, look at the file content state through the HSM.

Run the following command:

```bash
time lfs hsm_state /lustre/SEG_C3NA_Velocity.sgy
```

You can see that the file state changed from **released** to **archived**.

![Lustre lfs release](/images/fsx-for-lustre/lfs-state2.png)

Now, use the following command to see how much data is stored on the Lustre partition.

```bash
time lfs df -h
```

Do you notice a difference compared to the previous execution of this command? Instead of 13.5 MB of data stored, you now have 468.8 MB. In this case, it is stored on the second OST, your may see slightly different results.

![Lustre lfs release](/images/fsx-for-lustre/lfs-dh2.png)

#### Release the File Content

In this step, you release the file content. This action does not not delete nor remove the file itself. The metadata is still stored on the MDT.

Use the following command to release the file content:

```bash
time sudo lfs hsm_release /lustre/SEG_C3NA_Velocity.sgy
```

Then, run this command to see again how much data is stored on your file system.

```bash
time lfs df -h
```

You are back to 4.5 MB of stored data.

![Lustre lfs release](/images/fsx-for-lustre/lfs-dh3.png)

Access the file again and check how much time it takes.

```bash
time cat /lustre/SEG_C3NA_Velocity.sgy >/dev/shm/fsx
```

It should take around 4 seconds. Subsequent reads use the client cache. You can drop the caches, if desired.

![Lustre ls lah](/images/fsx-for-lustre/cat-file4.png)

In the next step, you install IOR, an IO parallel benchmark tool used to complete performance tests on your Lustre partition.
