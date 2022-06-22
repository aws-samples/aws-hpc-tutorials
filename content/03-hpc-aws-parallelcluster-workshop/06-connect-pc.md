+++
title = "e. Connect to your Cluster"
date = 2019-09-18T10:46:30-04:00
weight = 60
tags = ["tutorial", "initialize", "ParallelCluster"]
+++

Once you've waited a few minutes, your cluster should now be deployed. By clicking the create button you have deployed a cluster head node along with several resources used to create instances in the cluster's compute partition whenever jobs are submitted. The configuration you defined starts with 4 instances in this partition.

With all that information in mind, let's connect to your cluster and we will start submitting some jobs so that you can test out ParallelCluster.

1. Check that your cluster is successfully deployed as labeled by *1* in the screenshot below with the state *CREATE_COMPLETE*. If this state is reached, **Click** on the small *Shell* icon labeled by *2*.

![PCluster Manager Connection](/images/hpc-aws-parallelcluster-workshop/pcm-connect1.png)

2. A new tab in your web browser with access to the [GNU Bash](https://www.gnu.org/software/bash/) shell logged as the `ec2-user`.

![PCluster Manager Connection](/images/hpc-aws-parallelcluster-workshop/pcm-connect2.png)

You are logged in your HPC system and will run some commands to get familiar with it in the next section.



