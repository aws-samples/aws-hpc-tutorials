---
title: "b. Create Cost Controls"
weight: 82
---

In this section, you will implement a resource limit on the cluster using Slurm Accounting. [Slurm Resource Limits](https://slurm.schedmd.com/resource_limits.html) are used to enforce limits on the amount of resources that can be consumed. Our objective is to enforce a budget threshold in dollars; however, Slurm Accounting does not have a mechanism for understanding cloud costs associated with compute nodes. Therefore, you will convert a dollar budget to CPUMins group trackable resource minutes (GrpTRESMins) by using the AWS Price List API. You will then apply limits at the pcdefault Slurm account level for CPU Minutes in this lab.

#### 1. Get your SSH key name.
Run the command below in your **Cloud9 terminal** to retrieve the name of the SSH key.

```bash
source ~/environment/env_vars
echo ${SSH_KEY_NAME}
```

#### 2. Log in to the head node.
In this section, you will use the `pcluster ssh` command to connect to the head node from your AWS Cloud9 terminal.

```bash
pcluster ssh -n hpc --region ${AWS_REGION} -i ~/.ssh/${SSH_KEY_NAME}
```

#### 3. Apply budget to cluster.
Download the following python file as `create_cluster_cost_controls.py` within the */shared* directory.

```bash
cd /shared
curl ':assetUrl{path="/scripts/create_cluster_cost_controls.py"}' --output /shared/create_cluster_cost_controls.py
```
This script takes a single integer parameter that represents the US dollar budget limit that you would like to apply to the cluster. When executed, the script converts the budget to the number of used CPU minutes by compute nodes in the cluster.

Install the boto3 module that is a dependency of the python script.

```bash
pip3 install boto3
```

[Boto3](https://boto3.amazonaws.com/v1/documentation/api/latest/guide/index.html) is the AWS SDK for Python module.
The `create_cluster_cost_controls.py` script will use the boto3 module to get AWS credentials and interact with AWS service APIs.

Execute the python script to apply a budget of *$1000* to the cluster using the command below:

```bash
python3 create_cluster_cost_controls.py 1000
```

The python script has taken in the $1000 budget, calculated the cost per minute per core for the compute node EC2 instance type of hpc6id.32xlarge, and determined a total number of minutes that compute nodes can run before reaching the $1000 budget.
The total minutes is then applied as a CPUMins resource limit in Slurm Accounting.

::::expand{header="[Optional Information] Additional details about GrpTRESMins and CPUMins"}
GrpTRESMins (Group Trackable Resource Minutes) represents the total number of trackable resource minutes that can possibly be used by past, present, and future Slurm jobs running from an association and its children.  If any limit is reached, all running jobs with that trackable resource in this group will be killed and no new jobs will be allowed to run.

CPUMins (CPU Minutes) is a trackable resource representing the number of CPU minutes used by jobs.  As an example, a node with 64 CPUs running for 2 minutes would result in 128 CPUMins.
::::

#### 4. Verify that the budget is applied.
Use `sshare` to view the resource limit setting that you applied in the previous step.  Note that the resource limit was applied at the cluster level so you must retrieve data for the overall *pcdefault* account in Slurm.

```bash
sshare -u " " -A pcdefault -o account,user,GrpTRESMins,GrpTRESRaw 
```

::::expand{header="[Optional Information] Additional details about sshare and associations"}
**sshare** is used with the Slurm Priority Multifactor plugin and Slurm Accounting to provide share information by association. This command is useful in that it allows you to view both the resource limits (CPU Minutes limit in this lab) and the association's usage against that limit (the *pcdefault* Slurm account is the association that you use in this lab).
[sshare documentation](https://slurm.schedmd.com/sshare.html)

Slurm maintains a hierarchy of **association** entities that are used to group information: accounts, clusters, partitions, and users.
In this lab, you will focus on information at the *pcdefault* account level as this is the overarching account created by ParallelCluster.
[Slurm association documentation](https://slurm.schedmd.com/sacctmgr.html#OPT_association)
::::

Sample Output:

![sshare](/static/img/04-lab-4/sshare_show_limit.png)

Here you can see that a number of CPUMins (CPU minutes) has been applied as a limit to the overall cluster account, pcdefault. All of the GrpTRESRaw datapoints, which represent resource usage, are zero because you have not run any jobs since enabling Slurm resource limits.

::::expand{header="[Optional Information] Aside: where has this number for the limit come from?"}
The script we used to implement this limit takes as input the dollar budget, which in our case was 1000.
We then calculate the CPU minutes that this translates to with the following steps:
- Divide by the cost of the instance in the region ($6.0352 per hour)
- Multiply by 60 to switch from hours to minutes
- Multiply by 64, which is the number of CPUs per node
- Multiply by 0.9 to add a 10% safety factor in the calculation for other costs not related to compute

This gives a total budget in CPUmins of 572640.
::::

#### 5. Submit a new job.

```bash
cd /fsx/OpenFOAM/motorBikeDemo/
sbatch openfoam.sbatch
```

Now that resource limits are enabled, Slurm Accounting will begin to track resource usage. This configuration will be
tracking CPU Minutes (CPUMins) usage of the compute nodes in the cluster.

#### 6. Wait for the job to complete.

You can monitor the job state with `squeue`:

```bash
squeue -i 5
```

Wait for the job to complete - this will take **about 5 minutes**. You will know the job is complete once it disappears from the squeue output. Exit the infinite loop by doing `ctrl-c`.

In the next section, you will test the behavior of Slurm Accounting resource limits.
