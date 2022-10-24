+++
title = "g. Cleanup and Summary"
date = 2019-09-18T10:46:30-04:00
weight = 140
tags = ["tutorial", "lustre", "FSx", "S3"]
+++

In this lab you learnt how to create an FSx for Lustre file system, an S3 bucket as well as creating Data Repository Association between FSx for Lustre and S3. You also learnt how to update the cluster created in Lab I using AWS ParallelCluster and mounted the FSx for lustre on the compute instances and run HSM tests to realize automatic imports and exports of data to and from S3. 

Run the following commands on the Cloud9 terminal to delete the cluster and FSx for Lustre Filesystem

1. Exit from the Compute node and Cluster head node.
![exit](/images/fsx-for-lustre-hsm/exit-compute-head.png)

2. Delete the cluster created in Lab I. Note that you need to run this on the Cloud9 terminal, so ensure you have exited from the cluster completely. 

```bash
source env_vars
pcluster delete-cluster -n hpc-cluster-lab --region ${AWS_REGION}
```

3. Delete the Lustre Filesystem

```bash
aws fsx delete-file-system --file-system-id ${FSX_ID} --region ${AWS_REGION}
```

Congratulations, you have successfully completed Lab II. 
