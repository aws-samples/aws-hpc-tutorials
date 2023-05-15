+++
title = "File Cache on compute nodes"
date = 2023-04-10T10:46:30-04:00
weight = 100
tags = ["tutorial", "create", "ParallelCluster"]
+++

At the time of writing this Workshop Parallel Cluster doesn't support File Cache. So to mount the cache on the compute nodes we can update the script the comute instances run when they are first created. It is common to use a startup script to configure the compute nodes exactly as needed. The Cloud Cluster is already set to run a start up script, it was needed to syncronise the munge keys. When the compute node boots up, it downloads the script from S3 then runs it just before the instance is made available in Slurm.

Please log out from the Cluster and return to the Cloud9 Instance

First retrieve the cloud-compute script from S3

```bash
export S3_BUCKET=`aws s3 ls | grep pcluster-2023 | tail -n 1 |awk '{print $3}'`
export AWS_REGION=eu-west-1

aws s3 cp s3://${S3_BUCKET}/cloud-compute.sh cloud-compute.sh
chmod 755 cloud-compute.sh
```

Then update the script, by adding the following lines at the end of the script.

```bash
echo mkdir /mnt >> cloud-compute.sh
echo chown ec2-user.ec2-user -R /mnt >> cloud-compute.sh
echo mount -t lustre -o relatime,flock ${CACHE_DNS_NAME}:/${CACHE_MOUNT_POINT} /mnt >> cloud-compute.sh
ln -s /mnt/cache/data/ /data
```

Once the updates are in place, take a quick look and make sure it looks something like this:

```bash
#!/bin/bash
aws s3 cp s3://pcluster-2023-04-25-aaaaaaaa/munge.key /etc/munge/munge.key
chown munge.munge /etc/munge/munge.key
chmod 600 /etc/munge/munge.key
systemctl restart munge
systemctl restart slurmd
mkdir /mnt
chown ec2-user.ec2-user -R /mnt
mount -t lustre -o relatime,flock fc-aaaaaaaaaaa.fsx.eu-west-1.amazonaws.com:/bbbbbbbbb /mnt
ln -s /mnt/cache/data/ /data
```

As always, the exact paths must be different in your copy. When it looks correct, copy it back to S3.

```bash
aws s3 cp cloud-compute.sh s3://${S3_BUCKET}/cloud-compute.sh 
```

Now when new compute instances boot up they will mount the Cache filesystem.
