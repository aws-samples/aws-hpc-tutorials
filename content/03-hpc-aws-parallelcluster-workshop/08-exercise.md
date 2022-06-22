+++
title = "h. Optional - Playing with jobs"
date = 2019-09-18T10:46:30-04:00
weight = 90
tags = ["tutorial", "create", "ParallelCluster"]
+++

You have gained an understanding of the scaling mechanism of AWS ParallelCluster. As you have seen instances are created as you submit jobs.

#### Update the application execution time

You start by increasing the duration of your application execution time, then you recompile the MPI *hello world* application and submit multiple jobs. We won't give you the full commands here to make things a bit harder (but not by much).

1. Start by **modifying** the value of the `sleep` function call in `mpi_hello_world.c` to 60 seconds instead of 2 seconds. Use your favorite editor on Linux to do that. For example, `vi` or `nano`. If you prefer `emacs` install it via the command `sudo yum install emacs`.

2. Then **recompile** the code by running the command `mpicc` as in the previous section.

3. Submit multiple jobs by using the `sbatch` command as in the previous section. Just run it more than once (go for 10 times or more).

Now, if you check the status of your queue with `squeue`, you will see your jobs in the queue, one or slightly more will be running. You adjusted the duration the application run to last 5 minutes instead of a total of 10 seconds per job. T

#### Terminate all jobs

Once you are done, cancel all jobs by **typing** the command below in your shell.

```bash
squeue -u $USER -h | awk '{print $1}' | xargs scancel
```

If your execute the command `watch -n 5 sinfo`, the queue state will be refreshed every 5 seconds, you should see instances disappear after a few minutes.

Next, you can run through the optional exercise (we recommend it) or skip to Part II of the lab if you prefer to focus directly on the new AWS ParallelCluster API.
