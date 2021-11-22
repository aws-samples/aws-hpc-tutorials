+++
title = "h. Optional - Scaling in Action"
date = 2019-09-18T10:46:30-04:00
weight = 90
tags = ["tutorial", "create", "ParallelCluster"]
+++

You have gained an understanding of the scaling mechanism of AWS ParallelCluster. As you have seen instances are created as you submit jobs. We will now give you a small challenge: can you reach the maximum capacity of your cluster (i.e. 10 compute instances)? We'll give you some hints on how to get there.

#### Update the application execution time

You start by increasing the duration of your application execution time, then you recompile the MPI *hello world* application and submit multiple jobs. We won't give you the full commands here to make things a bit harder (but not by much).

1. Start by **modifying** the value of the `sleep` function call in `mpi_hello_world.c` to 60 seconds instead of 2 seconds. Use your favorite editor on Linux to do that. For example, `vi` or `nano`. If you need `emacs` install it with `sudo yum install emacs`.

2. Then **recompile** the code by running the command `mpicc` as in the previous section.

3. Submit multiple jobs by using the `sbatch` command as in the previous section. Just run it more than once (go for 10 times or more).

Now, if you check the status of your queue with `squeue`, you will see your jobs in the queue, one or slightly more will be running. You adjusted the duration the application run to last 5 minutes instead of a total of 10 seconds per job. This will force AWS ParallelCluster to create more instances to absorb the job backlog as compute instances will be busy for a longer period of time.


#### Check instances and jobs

You have submitted a minimum of 10 jobs (go for way more), take the following steps to see AWS ParallelCluster's scaling in action.

1. Check Slurm's queue state by **typing** the command `squeue` in your shell. This will list all jobs in *running* state and *waiting* in the queue.

2. **Run** the command `sinfo` to get the state of the instances and see how many joined the queue. They will be in the state `alloc`.

3. Go to the *AWS Console* in your lab account and open the [**Amazon EC2**](https://console.aws.amazon.com/ec2/) page.

You should see a maximum of 10 compute instances running your jobs. Non-running jobs will stay in the queue until they can get processed. Should you want to absorb this spike you could update your cluster to use more than 10 instances. In practice, administrators will limit the number of instances a given user can use to stay within reasonable limits. These can be of several thousands instances in some cases.

#### Terminate all jobs

Once you are done, cancel all jobs by **typing** the command below in your shell.

```bash
squeue -u $USER -h | awk '{print $1}' | xargs scancel
```

If your execute the command `watch -n 5 sinfo`, the queue state will be refreshed every 5 seconds, you should see instances disappear after a few minutes.

Next, you can run through the optional exercise (we recommend it) or skip to Part II of the lab if you prefer to focus directly on the new AWS ParallelCluster API.
