+++
title = "a. Create FSx Lustre Filesystem"
date = 2019-09-18T10:46:30-04:00
weight = 10
tags = ["configuration", "FSx", "ParallelCluster"]
+++

Creating a filesystem with FSx Lustre is easy, in this example we create the filesystem outside of the cluster then mount it. This has several advantages over creating the filesystem with AWS ParallelCluster.

* Filesystem persists after the cluster is deleted
* Filesystem can be shared across different clusters, allowing for blue/green deployments
* Newer deployment type (`PERSISTENT_2` which is 40% cheaper), and is not supported by AWS ParallelCluster yet, can be used.

In the lab, we setup the filesystem with the following options:

| FSx Lustre Parameter         | Definition                                                                                                                                                                                                 |
|------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **DataCompressionType**      | Data Compression both lowers storage size and increases throughput, set this to `LZ4`                                                                                                                      |
| **DeploymentType**           | Options are `SCRATCH_1`, `SCRATCH_2`, `PERSISTENT_1`, and `PERSISTENT_2`. I reccomend using persistent as opposed to scratch when mounting through AWS ParallelCluster. Scratch is ideal for per-job filesystems. |
| **PerUnitStorageThroughput** | Options are `125`, `250`, `500` or `1000` MB/s/TiB of throughput.                                                                                                                                             |

1. First on the [Cloud9](02-aws-getting-started/04-start_cloud9.html) instance you deployed in the getting started section, run the following command to create your filesystem:

```bash
# get subnet
INTERFACE=$(curl --silent http://169.254.169.254/latest/meta-data/network/interfaces/macs/)
SUBNET_ID=$(curl --silent http://169.254.169.254/latest/meta-data/network/interfaces/macs/${INTERFACE}/subnet-id)

FSX_ID=$(aws fsx create-file-system --file-system-type LUSTRE \
    --storage-capacity 1200 \
    --subnet-ids $SUBNET_ID \
    --lustre-configuration DataCompressionType=LZ4,DeploymentType=PERSISTENT_2,PerUnitStorageThroughput=125 \
    --tags Key=Name,Value=hpcworkshops \
    --query 'FileSystem.FileSystemId' --output text)
echo "export FSX_ID=${FSX_ID}" >> ~/.bashrc
```

2. After the filesystem is created, print out the filesystem id with `echo $FSX_ID`. We'll use to mount the filesystem.

```
$ echo $FSX_ID 
fs-0af2fd642c5a3e55c
```