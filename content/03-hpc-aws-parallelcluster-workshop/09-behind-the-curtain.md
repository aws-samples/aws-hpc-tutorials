+++
title = "g. Behind the Curtain"
date = 2019-09-18T10:46:30-04:00
weight = 100
tags = ["tutorial", "create", "ParallelCluster"]
+++

Now, learn what really happens in AWS when you submit a job and reveal a bit of the magic behind your automatic-scaling computational resources.

At the heart of AWS ParallelCluster exists an [Auto Scaling Group](https://docs.aws.amazon.com/autoscaling/ec2/userguide/AutoScalingGroup.html). It is a logical group of instances that can scale up and scale down based on a series of criteria. In the case of AWS ParallelCluster, there are three processes controlling the scaling of the cluster. These processes:

- Check the queue for any pending job and compute the total number of instances needed to process the queued jobs.
- Check if instances are busy over a cooldown period (600 seconds or 10 mins) and emit a heartbeat if they are not doing anything.
- Terminate instances and reduce Auto Scaling Groups if no jobs are waiting in the queue and some instances are sitting idle.

For more details on these processes, see [AWS ParallelCluster Processes](https://docs.aws.amazon.com/parallelcluster/latest/ug/processes.html).

#### Auto Scaling Groups

To learn more about how this works, take a detailed look at Auto Scaling Groups:

1. In the **AWS Management Console**, select the **EC2 Dashboard**, and in the left pane, choose [**Auto Scaling Groups**](https://console.aws.amazon.com/ec2/autoscaling). You should see an Auto Scaling Group with **Desired** at 0, **Min** at 0, and **Max** at 8. The Min and Max value correspond to the *min_queue_size* and *max_queue_size* of your cluster configuration file.
![ParallelCluster Create](/images/hpc-aws-parallelcluster-workshop/pc-auto-scaling.png)
2. Go back to your AWS Cloud9 environment and launch a 5 minutes *sleep* job with the following commands.
```bash
cat > sleep_script.sbatch << EOF
#!/bin/bash
#SBATCH --job-name=hello-world-job
#SBATCH --ntasks=2
#SBATCH --output=%x_%j.out

sleep 300
EOF
sbatch sleep_script.sbatch
```
4. Go back to the **EC2 Dashboard** and **Auto Scaling Groups**.
5. If necessary, click the refresh button (circling arrows). You should see that an instance just appeared on the desired field instead of 0. It corresponds to the 2 physical cores or c5.xlarge equivalent that you just requested.
![ParallelCluster Create](/images/hpc-aws-parallelcluster-workshop/pc-auto-scaling-2.png)
6. On the **EC2 Dashboard**, in the left pane, choose [**Instances**](https://console.aws.amazon.com/ec2/v2). You should see your compute instances labeled as *Compute*.
![ParallelCluster Create](/images/hpc-aws-parallelcluster-workshop/pc-ec2-compute.png)

Now you have a better understanding on how AWS ParallelCluster operates. For more information, see the [Configuration](https://docs.aws.amazon.com/parallelcluster/latest/ug/configuration.html) section of the *AWS ParallelCluster User Guide*.
