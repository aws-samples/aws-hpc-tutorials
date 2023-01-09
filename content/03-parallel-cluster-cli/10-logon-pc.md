+++
title = "i. Log in to Your Cluster"
date = 2019-09-18T10:46:30-04:00
weight = 45
tags = ["tutorial", "create", "ParallelCluster"]
+++

{{% notice tip %}}
The **pcluster ssh** is a wrapper around SSH. Depending on the case, you can also login to your head node using ssh and the public or private IP address.
{{% /notice %}}

You can list existing clusters using the following command. This is a convenient way to find the name of a cluster in case you forget it.

```bash
pcluster list-clusters
```

Now that your cluster has been created, login to the head node using the following command in your AWS Cloud9 terminal:

```bash
pcluster ssh --cluster-name hpc -i lab-your-key.pem
```

The EC2 instance asks for confirmation of the ssh login the first time you login to the instance. Type **yes**.
![SSH cluster](/images/hpc-aws-parallelcluster-workshop/ec2-ssh-connect.png)
