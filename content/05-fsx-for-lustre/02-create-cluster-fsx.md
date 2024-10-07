+++
title = "b. Create FSx Lustre"
date = 2019-09-18T10:46:30-04:00
weight = 20
tags = ["configuration", "FSx", "ParallelCluster"]
+++

#### Create FSx Filesystem

Creating a filesystem in AWS ParallelCluster is easy, we can directly specify the filesystem type, options and mount location. This gives several advantages over creating the filesystem outside of AWS ParallelCluster:

* Filesystem is automatically mounted to the cluster
* Filesystem is deleted when the cluster is deleted
* The cluster configuration file can be used to create the exact same setup in future deployments

In the lab, we setup the filesystem with the following options:

| FSx Lustre Parameter         | Definition                                                                                                                                                                                                 |
|------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **DataCompressionType**      | Data Compression both lowers storage size and increases throughput, set this to `LZ4`                                                                                                                      |
| **DeploymentType**           | Options are `SCRATCH_1`, `SCRATCH_2`, `PERSISTENT_1`, and `PERSISTENT_2`. I reccomend using persistent as opposed to scratch when mounting through AWS ParallelCluster. Scratch is ideal for per-job filesystems. |
| **PerUnitStorageThroughput** | Options are `125`, `250`, `500` or `1000` MB/s/TiB of throughput.  |

1. On the **Storage** tab, ensure the following options are set correctly:

![Cluster Wizard](/images/06-fsx-for-lustre/pcmanager-fsx.png)

2. Select the same **Subnet** from the previous step

![Cluster Wizard](/images/pcluster/pcmanager-4.png)

3. Click **Dry Run** to confirm the setup and then click **Create**

![Cluster Wizard](/images/pcluster/pcmanager-5.png)