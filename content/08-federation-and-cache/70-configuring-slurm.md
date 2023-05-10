+++
title = "Configuring Slurm"
date = 2019-09-18T10:46:30-04:00
weight = 70
tags = ["tutorial", "initialize", "ParallelCluster"]
+++

Now we have setup the security groups to allow communication, we can proceed and change the Slurm configuration. 

First lets findout the hostname of the headnode belonging to the onprem cluster. You should be logged into the Cloud9 instance.

```bash
pcluster ssh -n onprem -i ~/.ssh/ssh-key.pem -r ${AWS_REGION} hostname
ip-172-31-30-17
```

Keep a note of the name returned. You will need it in the next step. Don't use the example above. Login to the cloud cluster for the next few steps.

```bash
pcluster ssh -n cloud -i ~/.ssh/ssh-key.pem -r ${AWS_REGION}
sudo vi /opt/slurm/etc/slurm_parallelcluster.conf
```

Edit the file and change the AccountingStorageHost to the On-Prem headnode hostname you retrieved in the previous step. Note the IP addresses and names in this example are likely different to your cluster. The only change you need to make is to change the AccountingStorageHost value to match the onprem hostname you discovered a moment ago.

```bash
SlurmctldHost=ip-172-31-34-123(172.31.34.123)
SuspendTime=120
ResumeTimeout=1800
SelectTypeParameters=CR_CPU
AccountingStorageType=accounting_storage/slurmdbd
AccountingStorageHost=ip-172-31-30-17
AccountingStoragePort=6819
AccountingStorageUser=slurm
JobAcctGatherType=jobacct_gather/cgroup

include /opt/slurm/etc/pcluster/slurm_parallelcluster_cloudq_partition.conf

SuspendExcNodes=cloudq-st-c6i-[1-1]
```

Once the edit is done, save the file with :wq if you used vi, then proceed.

Now we need to restart the Slurmctld process so it rereads the configuration.

```bash
sudo systemctl restart slurmctld
```

If all goes well you should now be able to see both clusters if you run  the show clusters command:

```bash
sacctmgr show clusters
   Cluster     ControlHost  ControlPort   RPC     Share GrpJobs       GrpTRES GrpSubmit MaxJobs       MaxTRES MaxSubmit     MaxWall                  QOS   Def QOS
---------- --------------- ------------ ----- --------- ------- ------------- --------- ------- ------------- --------- ----------- -------------------- ---------
     cloud   172.31.34.123         6820  9728         1                                                                                           normal
    onprem    172.31.30.17         6820  9728         1                                                                                           normal
```

We need to now setup federation to configure the clusters to work together. A single command is all that is needed.

```bash
sacctmgr add federation fedone clusters=onprem,cloud
 Adding Federation(s)
  fedone
 Settings
  Cluster       = onprem
  Cluster       = cloud
Would you like to commit changes? (You have 30 seconds to decide)
(N/y): y
```

Now lets confirm the federation is working:
```bash
sacctmgr show federation
Federation    Cluster ID             Features     FedState
---------- ---------- -- -------------------- ------------
    fedone      cloud  2                            ACTIVE
    fedone     onprem  1                            ACTIVE
```

We now have a federated Slurm cluster setup. This means that we can submit jobs to either cluster from either headnode.

However aside from being linked via Slurm the 2 clusters are not combined. In the production world we would need to ensure a consistent mapping of user ids between the clusters and arrange a means of exchanging data between them.

In this lab we will work with a single user to keep things simple.
