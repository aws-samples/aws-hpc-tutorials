---
title: "Storage Lab"
date: 2019-01-24T09:05:54Z
weight: 300
pre: "<b>Lab III ⁃ </b>"
tags: ["HPC", "Overview", "Batch"]
---

[Amazon FSx for Lustre](https://aws.amazon.com/fsx/lustre/) provides a high-performance file system optimized for fast processing of workloads such as machine learning, high performance computing (HPC), video processing, financial modeling, and electronic design automation (EDA). These workloads commonly require data to be presented via a fast and scalable file system interface, and typically have datasets stored on long-term data stores like Amazon S3.

Amazon FSx for Lustre allows you to build a Lustre file system based with an Amazon S3 backend. Files can be transferred between the Lustre partition and Amazon S3 using Lustre Hierarchical Storage Management (HSM). The size of your file system determines how much throughput is provided by Amazon FSx for Lustre. For more details, see the [Amazon FSx for Lustre Performance](https://docs.aws.amazon.com/fsx/latest/LustreGuide/performance.html).

One key advantage of Amazon FSx for Lustre is that you can create a Lustre partition based on the required size or throughput you need. If linked to an Amazon S3 bucket, the size of the Lustre partition can be lesser than the total size of the Amazon S3 bucket. Amazon FSx for Lustre copies the metadata from the objects stored in the bucket, but the actual content or bytes of the files are not retrieved until needed. For more details, see [Using Data Repositories with Amazon FSx for Lustre](https://docs.aws.amazon.com/fsx/latest/LustreGuide/fsx-data-repositories.html).

{{% notice info %}}
This workshop requires an AWS Cloud9 IDE. If you do not have an AWS Cloud9 IDE set up, complete sections [a. Sign in to the Console](/02-aws-getting-started/03-aws-console-login.html) through [d. Work with the AWS CLI](/02-aws-getting-started/05-start-aws-cli.html) in the [Getting Started in the Cloud](/02-aws-getting-started.html) workshop.
This workshop also requires familiarity with AWS ParallelCluster. If you are not familiar with AWS ParallelCluster, first complete the [AWS ParallelCluster](/03-hpc-aws-parallelcluster-workshop.html) workshop.
{{% /notice %}}

In this workshop, you learn how to use [Amazon FSx for Lustre](https://aws.amazon.com/fsx/lustre/) with [AWS ParallelCluster](https://aws.amazon.com/hpc/parallelcluster/) and complete the following steps:

- Upload files from an AWS Cloud9 instance to an Amazon S3 bucket.
- Create a new cluster with AWS ParallelCluster and Amazon FSx for Lustre.
- Run an IO intensive application to test Lustre performances.
- Push and get files using Lustre HSM.
- Delete the cluster and the Lustre partition.

