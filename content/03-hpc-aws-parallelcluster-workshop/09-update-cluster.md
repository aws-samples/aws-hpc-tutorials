+++
title = "h. Update your cluster"
date = 2019-09-18T10:46:30-04:00
weight = 100
tags = ["tutorial", "create", "ParallelCluster"]
+++

We have sucessfully built your cluster and ran your first MPI job.

Let's say you want to add another queue to your cluster say for example with **c4.large** . In this section, you will learn how to update your cluster with new queue. 

Go back to your AWS Cloud9 environment, and stop the cluster

```bash
pcluster list -r $AWS_REGION
```

```bash
pcluster stop hpclab-yourname -r $AWS_REGION
```

Save your original config file, just in case you want to refer to any settings before the update

```bash
mv my-cluster-config.ini my-cluster-config-org.ini
```

In this step you will be re-writing the original config file with the new updates. Please pay attention to the **queue_settings** with a new queue added and also corresponding **queue** and **compute_resource** settings which describe the new queue with c4.large instance type.

```bash
cat > my-cluster-config.ini << EOF
[global]
cluster_template = default
update_check = false
sanity_check = true

[vpc public]
vpc_id = ${VPC_ID}
master_subnet_id = ${SUBNET_ID}

[cluster default]
key_name = ${SSH_KEY_NAME}
base_os = ${BASE_OS}
scheduler = ${SCHEDULER}
master_instance_type = c5.xlarge
s3_read_write_resource = *
vpc_settings = public
ebs_settings = myebs
queue_settings = compute,newqueue

[queue compute]
compute_resource_settings = default
disable_hyperthreading = true
placement_group = DYNAMIC

[compute_resource default]
instance_type = c5.large
min_count = 0
max_count = 8

[queue newqueue]
compute_resource_settings = c4queue
disable_hyperthreading = true
placement_group = DYNAMIC

[compute_resource c4queue]
instance_type = c4.large
min_count = 0
max_count = 8

[ebs myebs]
shared_dir = /shared
volume_type = gp2
volume_size = 20

[aliases]
ssh = ssh {CFN_USER}@{MASTER_IP} {ARGS}
EOF
```

If you like you could run a **diff** command to notice the new changes made to the config file 

```bash
vimdiff my-cluster-config-org.ini my-cluster-config.ini
```

Then run a **pcluster update** command

```bash
pcluster update hpclab-yourname -c my-cluster-config.ini -r $AWS_REGION
```

Pay attention to the **old value** and **new value** fields. You will see a new queue and corresponding sections added under new value field. The output will be similar to this


![ParallelCluster Update](/images/hpc-aws-parallelcluster-workshop/pc-update-queue.png)


Start your cluster again after update process is completed.

```bash
pcluster start hpclab-yourname -r $AWS_REGION
```

You can see that the cluster now has a new partition with c4.large in addition to the c5.large queue created previously

```bash
[ec2-user@ip-172-31-46-11 ~]$ sinfo
PARTITION AVAIL  TIMELIMIT  NODES  STATE NODELIST
compute*     up   infinite      8  idle~ compute-dy-c5large-[1-8]
newqueue     up   infinite      8  idle~ newqueue-dy-c4large-[1-8]
```

You can now login to your cluster and run your helloworld job again and this time choose to run it on the c4.large instance. You can do this by specifying the slurm partion parameter in your sbatch script to point to **newqueue** 

```bash
cat > submission_script_newqueue.sbatch << EOF
#!/bin/bash
#SBATCH --job-name=hello-world-job
#SBATCH --ntasks=4
#SBATCH --partition=newqueue
#SBATCH --output=%x_%j.out

mpirun ./mpi_hello_world
EOF
```

With this you can run an **squeue** command to see that the job you submitted is running on the new partition with c4.xlarge instance

```bash
[ec2-user@ip-172-31-46-11 ~]$ squeue -a
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                 3  newqueue hello-wo ec2-user  R       0:06      4 newqueue-dy-c4large-[1-4]
``` 

The output will also show that the job ran on c4.xlarge instance

```bash
[ec2-user@ip-172-31-46-11 ~]$ more hello-world-job_3.out
Hello World from Step 1 on Node 2, (newqueue-dy-c4large-3)
Hello World from Step 1 on Node 0, (newqueue-dy-c4large-1)
Hello World from Step 1 on Node 3, (newqueue-dy-c4large-4)
Hello World from Step 1 on Node 1, (newqueue-dy-c4large-2)
Hello World from Step 2 on Node 2, (newqueue-dy-c4large-3)
Hello World from Step 2 on Node 0, (newqueue-dy-c4large-1)
Hello World from Step 2 on Node 3, (newqueue-dy-c4large-4)
Hello World from Step 2 on Node 1, (newqueue-dy-c4large-2)
Hello World from Step 3 on Node 2, (newqueue-dy-c4large-3)
Hello World from Step 3 on Node 0, (newqueue-dy-c4large-1)
Hello World from Step 3 on Node 3, (newqueue-dy-c4large-4)
Hello World from Step 3 on Node 1, (newqueue-dy-c4large-2)
Hello World from Step 4 on Node 2, (newqueue-dy-c4large-3)
Hello World from Step 4 on Node 0, (newqueue-dy-c4large-1)
Hello World from Step 4 on Node 1, (newqueue-dy-c4large-2)
Hello World from Step 4 on Node 3, (newqueue-dy-c4large-4)
```

Now you have a better understanding on how AWS ParallelCluster operates. For more information, see the [Configuration](https://docs.aws.amazon.com/parallelcluster/latest/ug/configuration.html) section of the *AWS ParallelCluster User Guide*.
