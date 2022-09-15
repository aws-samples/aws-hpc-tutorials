---
title: "FSx for Lustre and S3"
date: 2022-04-11T09:05:54Z
weight: 30
pre: "<b>Lab II ⁃ </b>"
tags: ["HPC", "Overview"]
---
In this lab, you are introduced to [Amazon FSx for Lustre](https://aws.amazon.com/fsx/lustre/). You will create a new FSx for Lustre file system and experience HSM capabilities. For HSM you will create an S3 bucket and link it to the lustre file system created and monitor imports and exports. 

- Create a new FSx for Lustre file system via FSx console
- Create an s3 bucket and upload test data
- Create a Data Repository Action with this S3 bucket on the FSx for lustre filesystem via the FSx console
- Launch an Amazon EC2 instance and prepare the instance to mount the newly created filesystem
- Login to the EC2 instance, take a look at the FS and verify HSM properties
- Clean up the file system and EC2 instance and verify all the data present in the S3 bucket created 

#### About Amazon FSx for Lustre and HSM

[Amazon FSx for Lustre](https://docs.aws.amazon.com/fsx/latest/LustreGuide/what-is.html) makes it easy and cost-effective to launch and run the popular, high-performance Lustre file system. You use Lustre for workloads where speed matters, such as machine learning, high performance computing (HPC), video processing, and financial modeling.

The open-source Lustre file system is designed for applications that require fast storage—where you want your storage to keep up with your compute. Lustre was built to solve the problem of quickly and cheaply processing the world's ever-growing datasets. It's a widely used file system designed for the fastest computers in the world. It provides sub-millisecond latencies, up to hundreds of GBps of throughput, and up to millions of IOPS. For more information on Lustre, see the [Lustre website](https://www.lustre.org/).

As a fully managed service, Amazon FSx makes it easier for you to use Lustre for workloads where storage speed matters. FSx for Lustre eliminates the traditional complexity of setting up and managing Lustre file systems, enabling you to spin up and run a battle-tested high-performance file system in minutes. It also provides multiple deployment options so you can optimize cost for your needs.

FSx for Lustre is POSIX-compliant, so you can use your current Linux-based applications without having to make any changes. FSx for Lustre provides a native file system interface and works as any file system does with your Linux operating system. It also provides read-after-write consistency and supports file locking.

### HSM and Data Repository with S3

[HSM](https://en.wikipedia.org/wiki/Hierarchical_storage_management) also known as tiered storage,is a data storage and Data management technique that automatically moves data between high-cost and low-cost storage media.

When you use Amazon FSx with multiple durable storage repositories, you can ingest and process large volumes of file data in a high-performance file system by using automatic import and import data repository tasks. At the same time, you can write results to your data repositories by using automatic export or export data repository tasks. With these features, you can restart your workload at any time using the latest data stored in your data repository.

Amazon FSx is deeply integrated with [Amazon S3](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Welcome.html). This integration means that you can seamlessly access the objects stored in your Amazon S3 buckets from applications that mount your Amazon FSx file system. You can also run your compute-intensive workloads on Amazon EC2 instances in the AWS Cloud and export the results to your data repository after your workload is complete. 

In Amazon FSx for Lustre, you can import file and directory listings from your linked data repositories to the file system using automatic import or using an import data repository task. When you turn on automatic import on a data repository association, your file system imports file metadata as files are created, modified, and/or deleted in the S3 data repository. FSx for Lustre handles the [HSM](https://en.wikipedia.org/wiki/Hierarchical_storage_management) automatically. Alternatively, you can import metadata for new or changed files and directories using an import data repository task. Both automatic import and import data repository tasks include POSIX metadata.

