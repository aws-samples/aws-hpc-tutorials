+++
title = "e. Summary & Cleanup"
date = 2019-09-18T10:46:30-04:00
weight = 420
tags = ["tutorial", "Monitoring", "ParallelCluster", "SNS", "Slurm", "Job Notification"]
+++

In the previous sections, you setup an HPC cluster with system monitoring and performance dashboards. You then updated the cluster to send email notifications after the job completes. Now we'll tear down that infrastructure.

First, from the cluster, delete the SNS topic you created:

```bash
sns delete-topic --topic-arn ${MY_SNS_TOPIC}
```

Then from Cloud9, delete the cluster. This removes all the resources created for the cluster, including the filesystem, grafana dashboard, master node and compute nodes.

```bash
exit # exit to cloud9 instance
pcluster delete perflab-yourname
```

At any time you can re-create the cluster by running `pcluster create perflab-yourname -c ~/environment/my-perf-cluster-config.ini` as shown in the [BUILD YOUR HPC CLUSTER](10-monitoring/grafana/03-launch-pc.html) section.