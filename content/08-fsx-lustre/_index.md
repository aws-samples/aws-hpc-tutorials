---
title: "FSx for Lustre and S3"
date: 2022-04-11T09:05:54Z
weight: 30
pre: "<b>Lab II ⁃ </b>"
tags: ["HPC", "Overview"]
---
In this lab, you are introduced to [Amazon FSx for Lustre](https://aws.amazon.com/fsx/lustre/). You will create a new FSx for Lustre file systemand experience HSM capabilities. For HSM we will create an S3 bucket and link it to the lustre file system created and monitor imports and exports. 

- Create a new FSx for Lustre file system via FSx console
- Create an s3 bucket and upload test data
- Create a Data Repository Action with this S3 bucket on the FSx for lustre filesystem via the FSx console
- Launch an Amazon EC2 instance and prepare the instance to mount the newly created filesystem
- Login to the EC2 instance, take a look at the FS and verify HSM properties
- Clean up the file system and EC2 instance and verify all the data present in the S3 bucket created 

