+++
title = "m. Run WRF"
date = 2022-04-10T10:46:30-04:00
weight = 110
tags = ["tutorial", "create", "ParallelCluster"]
+++

#### Submit your First Job

Submitted jobs are immediately processed if the job is in the queue and a sufficient number of compute nodes exist.

If there are not enough compute nodes to satisfy the computational requirements of the job, such as the number of cores, AWS ParallelCluster creates new instances to satisfy the requirements of the jobs sitting in the queue. However, note that you determined the minimum and maximum number of nodes when you created the cluster. If the maximum number of nodes is reached, no additional instances will be created.

Submit your first job using the following command on the head node:

```bash
sbatch slurm-c5n-wrf-conus12km.sh
```

Check the status of the queue using the command **squeue**. The job will be first marked as pending (*PD* state) because resources are being created (or in a down/drained state). If you check the [EC2 Dashboard](https://console.aws.amazon.com/ec2), you should see nodes booting up.

```bash
squeue 
```
When ready and registered, your job will be processed and you will see a similar status as below.
![squeue output](/images/hpc-aws-parallelcluster-workshop/squeue-output.png)

You can also check the number of nodes available in your cluster using the command **sinfo**. Do not hesitate to refresh it, nodes generally take less than 5 min to appear.

```bash
sinfo
```
 The following example shows 2 nodes.
![squeue output](/images/hpc-aws-parallelcluster-workshop/sinfo-output.png)

Once the job has been processed, you should see similar results as follows in one of the rsl.out.* files:

Look for "SUCCESS COMPLETE WRF" at the end of the rsl* file.

![squeue output](/images/hpc-aws-parallelcluster-workshop/helloworld-output.png)


Done!

After a few minutes, your cluster will scale down unless there are more job to process.


Exit the HPC Cluster
```bash
exit
```