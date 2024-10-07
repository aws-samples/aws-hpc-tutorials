---
title: "c. Test Cost Controls"
weight: 83
---

In this section, we will query the Slurm accounting database, and then submit jobs to observe how the applied resource limits affects our job execution.

#### 1. Observe job execution statistics.
Use the `sacct` command to observe the Slurm Accounting job execution statistics for the previously executed job:

```bash
sacct --format=jobid,jobname,partition,account,state,elapsed,alloccpus,allocnodes,cputime --allocations --starttime now-2days
```

![sacct](/static/img/04-lab-4/sacct.png)

Note that you can see the runtime of the previously executed jobs as well as the number of nodes and CPUs that were
allocated to that jobs execution. These values are used in Slurm Accounting to track against the CPUMins GrpTRESMins
limit. 

#### 2. Observe the current CPU resource limit.
Use the `sshare` command to observe the current GrpTRESMins CPU limit at the account level as well as how close the cluster is to approaching that limit.

```bash
sshare -u " " -A pcdefault -o account,user,GrpTRESMins,GrpTRESRaw 
```

![sshare_usage](/static/img/04-lab-4/sshare_show_usage.png)

Because this limit is set at the cluster level, observe the output where `Account=pcdefault`
and `UserName=` as this provides the account-level data. The upper limit should be the same but
note that the current value may differ due to varying run times.

In this case, we can see that job 2 ran for 1 minute and 22 seconds, which is 1.366 minutes. It ran on 2 nodes, which is 128 CPUs. Therefore, the consumed CPUmins (since reporting started) was 174, which is the reported value in this image.

#### 3. Lower the budget limit.

Re-run the cost control script but this time use an arbitrarily low budget threshold of *$.05*.

```bash
python3 /shared/create_cluster_cost_controls.py .05
```

You are doing this to force the resource limit to be reached so that you can observe Slurm's behavior.

#### 4. Submit a new job.
 ```bash
sbatch openfoam.sbatch
 ```

#### 5. View job status.
Use the `squeue` command to view the status of the job that was just submitted.
 ```bash
squeue
 ```

![squeue_pending](/static/img/04-lab-4/squeue_pending.png)

Note how the job is stuck in the Pending state as denoted by ST=PD. You can also see that the reason for the job
being stuck in the pending state is `AssocGrpCPUMinutesLimit`, meaning that you have exceeded our CPUMins resource
limit threshold. Slurm will not allow new jobs to be executed until the resource limit is raised or reset.

#### 6. Raise the budget limit.
Re-run the cluster cost controls python script to reset the applied budget back to *$1000*.
```bash
python3 /shared/create_cluster_cost_controls.py 1000
```
In the subsequent steps you will be able to see Slurm's behavior when the budget has been raised back.

#### 7. Check the job status.
Note that Slurm will automatically start the job once the limit is reset, but it may take up to a couple of minutes before Slurm recognizes that the CPUMins limit has been increased and the job
executes. To save time, you will requeue the job. First, find the job_id using the `squeue` command.
 ```bash
squeue
 ```

#### 8. Requeue the job.
The `scontrol` command below re-queues job_id 3 but replace "3" with your job_id from the `squeue` command above in step 7.
```bash
scontrol requeue 3
```

#### 9. Monitor the job state.

```bash
squeue -i 5
```

The job has been re-queued but it may take up to **3 minutes** for the job to start running due to a [BeginTime](https://slurm.schedmd.com/squeue.html#OPT_BeginTime) limitation.
When a Slurm job is re-queued, the re-queued job's begin time is moved forward a couple of minutes to ensure that the previous job is cleaned up before the re-queued job starts.

![squeue_begintime](/static/img/04-lab-4/squeue_begintime.png)

Wait for the job to transition into the **running** state.  You will know that the job is in the **running** state when you see the following, denoted by **ST=R**:

![squeue_running](/static/img/04-lab-4/squeue_running.png)

#### 10. Exit the infinite loop by doing `ctrl-c`.

You have learned how to apply Slurm Accounting resource limits to your cluster as a means to implement cost controls.
In the next section, you will learn how to visualize cost data in Amazon CloudWatch.