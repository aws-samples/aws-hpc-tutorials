+++
title = "Examine Slurm Configuration"
date = 2023-04-10T10:46:30-04:00
weight = 50
tags = ["tutorial", "create", "ParallelCluster"]
+++


Before we move on, lets quickly validate the setup of the two clusters. First lets connect to onprem cluster and verify that the Slurm is working.

Before we can connect we need the ssh key, lets fetch the ssh key from S3. We will retrieve it, save in the .ssh folder and assign appropriate permissons.

```bash
export S3_BUCKET=`aws s3 ls | grep pcluster-2023 | tail -n 1 |awk '{print $3}'`
export AWS_REGION=eu-west-1

aws s3 cp s3://${S3_BUCKET}/ssh-key.pem ~/.ssh/ssh-key.pem
chmod 600 ~/.ssh/ssh-key.pem
```

Now we have a key we can login to the Onprem cluster

```bash
pcluster ssh -n onprem -i ~/.ssh/ssh-key.pem -r ${AWS_REGION}
```

Once logged in we can validate that the cluster works.

Try a few Slurm commands such as:

```bash
sinfo
PARTITION AVAIL  TIMELIMIT  NODES  STATE NODELIST
onpremq*     up   infinite      1   idle onpremq-st-c6i-1

squeue
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)

And then submit a job.

cat << EOF >> test.sh
#!/bin/bash
hostname
sleep 30
EOF

sbatch test.sh

squeue
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                 1    cloudq  test.sh ec2-user  R       0:02      1 cloudq-st-c6i-1


```

The Onprem cluster is setup with at least one compute node constantly running, so the job should start to run quite quickly.