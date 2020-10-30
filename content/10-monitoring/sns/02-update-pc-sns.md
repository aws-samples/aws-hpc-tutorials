+++
title = "a. Update cluster with SNS Policy"
date = 2019-09-18T10:46:30-04:00
weight = 300
tags = ["tutorial", "Monitoring", "ParallelCluster", "SNS", "IAM"]
+++

In this section, we will re-use the cluster that was created in the earlier section for Grafana dashboard visualization and just update the Identity and Access Management (IAM) policies to enable full SNS access to the cluster. 

You just need to update the "additional_iam_policies" section in the cluster configuration created earlier


additional_iam_policies=arn:aws:iam::aws:policy/CloudWatchFullAccess,arn:aws:iam::aws:policy/AWSPriceListServiceFullAccess,arn:aws:iam::aws:policy/AmazonSSMFullAccess,arn:aws:iam::aws:policy/AWSCloudFormationReadOnlyAccess,**arn:aws:iam::aws:policy/AmazonSNSFullAccess**


- In the AWS Cloud9 terminal, paste the following commands in your terminal

```bash
cd ~/environment
```

- Install a simple utility (**crudini**) to modify/update ini files

```bash
sudo pip3 install iniparse
git clone https://github.com/pixelb/crudini.git
```

- Update the ParallelCluster Configuration file created in the earlier section and update the IAM policy as below

```bash
./crudini/crudini --set --list --existing my-perf-cluster-config.ini "cluster default" additional_iam_policies arn:aws:iam::aws:policy/AmazonSNSFullAccess
```

- Update the cluster as follows

```bash
pcluster update perflab-yourname -c my-perf-cluster-config.ini
```

AWS ParallelCluster will validate the configuration update and ask for confirmation. Say "Y". You should see an output as shown below

Wait for your cluster to be updated with the new added policy.

![SNS PC Update](/images/monitoring/sns-pc-update.png)




