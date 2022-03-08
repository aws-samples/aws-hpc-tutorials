+++
title = "b. Build a HPC Cluster with NICE DCV"
date = 2019-09-18T10:46:30-04:00
weight = 70
tags = ["tutorial", "create", "ParallelCluster"]
+++

In this section, you create a cluster based on the specifications defined in the configuration file. To create a cluster, you use the command **pcluster create-cluster** and the **--cluster-configuration** (or **-c**) option to specify the cluster configuration file.

In your AWS Cloud9 terminal, run the following to create a cluster. Make sure that the configuration file path is correct.

```bash
pcluster create-cluster --cluster-name my-dcv-cluster -c dcv-config.yaml
```

Your cluster will take a few minutes to build. The creation status is displayed in your terminal. Once the cluster is ready, you should see cluster in the listing as below.

```bash
$ pcluster list-clusters
{
  "clusters": [
    {
      "clusterName": "my-dcv-cluster",
      "cloudformationStackStatus": "CREATE_COMPLETE",
      "cloudformationStackArn": "arn:aws:cloudformation:xxxxx
      "region": "eu-west-1",
      "version": "3.1.2",
      "clusterStatus": "CREATE_COMPLETE"
    }
  ]
}
```
{{% notice tip %}}
There can be only one cluster of a given name at any time on your account.
{{% /notice %}}


