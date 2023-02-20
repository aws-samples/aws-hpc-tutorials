+++
title = "k. Run WRF"
date = 2022-04-10T10:46:30-04:00
weight = 110
tags = ["tutorial", "create", "ParallelCluster"]
+++

#### Submit your First Job

Submitted jobs are immediately processed if the job is in the queue and a sufficient number of compute nodes exist.

If there are not enough compute nodes to satisfy the computational requirements of the job, such as the number of cores, AWS ParallelCluster creates new instances to satisfy the requirements of the jobs sitting in the queue. However, note that you determined the minimum and maximum number of nodes when you created the cluster. If the maximum number of nodes is reached, no additional instances will be created.

Submit your first job using the following command on the head node:

```bash
cd /shared/conus_12km
sbatch slurm-wrf-conus12km.sh
```

Check the status of the queue using the command **squeue**. The job will be first marked as pending (*PD* state) because resources are being created (or in a down/drained state). If you check the [EC2 Dashboard](https://console.aws.amazon.com/ec2), you should see nodes booting up.

```bash
squeue
```
When ready and registered, your job will be processed and you will see a similar status as below.
```console
[ec2-user@ip-172-31-27-78 conus_12km]$ squeue
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                 1    queue0 WRF-CONU ec2-user CF       0:21      1 queue0-dy-c524xl
[ec2-user@ip-172-31-27-78 conus_12km]$
```

You can also check the number of nodes available in your cluster using the command **sinfo**. Do not hesitate to refresh it, nodes generally take less than 5 min to appear.

```bash
sinfo
```
 The following example shows 2 nodes.
```console
[ec2-user@ip-172-31-27-78 conus_12km]$ sinfo
PARTITION AVAIL  TIMELIMIT  NODES  STATE NODELIST
queue0*      up   infinite      1 alloc# queue0-dy-c524xl
[ec2-user@ip-172-31-27-78 conus_12km]$
```

Once the job has been processed, you should see similar results as follows in one of the rsl.out.* files:

Look for "SUCCESS COMPLETE WRF" at the end of the rsl.out.0000 file.

```console
[ec2-user@ip-172-31-27-78 conus_12km]$ tail rsl.out.0000
Timing for main: time 2019-11-26_23:51:36 on domain   1:    0.43119 elapsed seconds
Timing for main: time 2019-11-26_23:52:48 on domain   1:    0.42961 elapsed seconds
Timing for main: time 2019-11-26_23:54:00 on domain   1:    0.43015 elapsed seconds
Timing for main: time 2019-11-26_23:55:12 on domain   1:    0.42956 elapsed seconds
Timing for main: time 2019-11-26_23:56:24 on domain   1:    0.43012 elapsed seconds
Timing for main: time 2019-11-26_23:57:36 on domain   1:    0.42867 elapsed seconds
Timing for main: time 2019-11-26_23:58:48 on domain   1:    0.42858 elapsed seconds
Timing for main: time 2019-11-27_00:00:00 on domain   1:    0.43009 elapsed seconds
Timing for Writing wrfout_d01_2019-11-27_00:00:00 for domain        1:    8.84589 elapsed seconds
wrf: SUCCESS COMPLETE WRF
[ec2-user@ip-172-31-27-78 conus_12km]$
```


Done!

After a few minutes, your cluster will scale down unless there are more job to process.
