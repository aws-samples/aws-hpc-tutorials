+++
title = "Running a test job"
date = 2023-04-10T10:46:30-04:00
weight = 105
tags = ["tutorial", "create", "ParallelCluster"]
+++

Now we have the File Cache and Federation setup. So we are now ready to run a job and check that everything is wokring.

If you are logged into the cloud cluster, please logout, then login to the Onprem cluster.

```bash
pcluster ssh -n onprem -i ~/.ssh/ssh-key.pem -r ${AWS_REGION}
```

Once logged in, cd into the /data folder and create a file called input.txt containing the string "world".

```bash
cd /data
cat << EOF >> /data/input.txt
world
EOF
```

As a quick test that the jobs are forwarding and the data is synced correctly we can run a quick test.

```bash
cat << EOF >> /data/testjob.sh
#!/bin/bash
cd /data

# Do something with the input file.
echo hello `cat input.txt`
echo hello `cat input.txt` > output.txt

# Sync the output back to the NFS share
sudo lfs hsm_archive output.txt
EOF

cd /data
sbatch -Mcloud testjob.sh
```

The job may take a couple of minutes to run as a new compute instance will need to be provisioned. If you already have a running instance, then the new startup script will not of had chance to run. You can either wait until the instance terminates, which will be 10 minutes after its last job. Or ssh to it (from the cloud headnode, ssh keys are already setup), and run the same mount commands you ran on the headnode. Don't forget the link from /data to /mnt/cache/data.

Note in the run script we don't need to use hsm_restore to load the input.txt file, this happens automatically.
The -M option specifies the Slurm cluster to use to run the job. In a production scenario we would likely use features and constraints to control where the job runs. In this lab we are keeping it simple.
