+++
title = "a. Update cluster with SNS Policy"
date = 2019-09-18T10:46:30-04:00
weight = 300
tags = ["tutorial", "Monitoring", "ParallelCluster", "SNS", "IAM"]
+++

In this section, we will re-use the cluster that was created in the earlier section for Grafana dashboard visualization and just update the Identity and Access Management (IAM) policies to enable full SNS access to the cluster. 

You just need to update the **additional_iam_policies** section in the cluster configuration as follows:

```ini
additional_iam_policies=...,arn:aws:iam::aws:policy/AmazonSNSFullAccess
```

1. First install a simple utility (**crudini**) to modify/update ini files:

```bash
sudo pip3 install iniparse
git clone https://github.com/pixelb/crudini.git
```

3. Update the config file with the additional IAM policy:

```bash
./crudini/crudini --set --list --existing ~/environment/my-perf-cluster-config.ini "cluster default" additional_iam_policies arn:aws:iam::aws:policy/AmazonSNSFullAccess
```

4. Update the cluster:

```bash
pcluster update perflab-yourname -c ~/environment/my-perf-cluster-config.ini
```

AWS ParallelCluster will validate the configuration update and ask for confirmation. Type "Y". You should see an output as shown below:

![SNS PC Update](/images/monitoring/sns-pc-update.png)

Wait for your cluster to be updated with the new added policy.

