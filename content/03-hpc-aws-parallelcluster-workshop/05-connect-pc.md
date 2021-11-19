+++
title = "d. Connect to your Cluster"
date = 2019-09-18T10:46:30-04:00
weight = 60
tags = ["tutorial", "initialize", "ParallelCluster"]
+++

Your cluster is now created after a few minutes. In essence you deployed a head-node and several resources whose role is to create instances in the compute partition when jobs are submitted. The configuration that you defined starts with 0 instances in this partition and can scale up to 10.

When submitting a job, AWS ParallelCluster will request new instances to be created through the Slurm power management feature. If you submit a parallel jobs that requires the equivalent of 2 instances, then AWS ParallelCluster will request the creation of those 2 instances.

Additional jobs running concurrently on the machine will cause additional instances to be created until you reach the upper limit of 10. Once it is reached, jobs will wait in the queue until vCPUs are freed-up to place these jobs. Once all jobs are processed and instances are idle for a given period, then AWS ParallelCluster will terminate these instances. And you know the best? All this lifecycle is automated, the end-users do not have to worry about the scaling of these instances and the cost of maintaining idle compute resources.

With all that information, let's connect to your cluster and we will start submitting some jobs in the next section.


1. Check that your cluster is successfully deployed as labelled by *1* in the screenshot below with the state *CREATE_COMPLETE*. If this state is reached, **Click** on the small *Shell* icon labelled by *2*.

![Pcluster Manager Connection](/images/hpc-aws-parallelcluster-workshop/pcm-connect1.png)

2. A new tab in your web browser with access to the [GNU Bash](https://www.gnu.org/software/bash/) shell logged as the `ec2-user`.

![Pcluster Manager Connection](/images/hpc-aws-parallelcluster-workshop/pcm-connect2.png)

You are logged in your HPC system and will run some commands to get familiar with it in the next section.
