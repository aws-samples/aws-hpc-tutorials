+++
title = "c. Review the Grafana Dashboards"
date = 2019-09-18T10:46:30-04:00
weight = 30
tags = ["tutorial", "Grafana", "ParallelCluster", "Monitoring", "Dashboards"]
+++

In this section, you will review the Grafana Monitoring Dashboard that's created as part of your cluster.

After your cluster is created, you can just open a web-browser and connect to head node of your cluster using its public ip. A landing page will be presented to you with links to the Prometheus database service and the Grafana dashboards.

To get the public ip of the head node of your cluster using the **pcluster status** command as follows:

```bash
pcluster status perflab-yourname
```

You should see an output similar to the one shown below

![ParallelCluster Status](/images/monitoring/pc-head-ip.png)


Open a browser (e.g. Chrome or Firefox) and connect to the head node of your cluster using the public ip address `https://PUBLIC_IP`. Click on **GRAFANA DASHBOARDS** on the landing page as shown below:

![Grafana Landing](/images/monitoring/grafana-db-landing.png)


Login to the Grafana dashboards using the below username and password

**username**: admin

**Password**: Grafana4PC!

**Note**: If you modified the username or Password in the post_install script when deploying the cluster, use the updated credentials. 

![Grafana Landing](/images/monitoring/grafana-db-login.png)

In the Welcome page, click on the **Dashboards** -> **Manage** icon as shown

![Grafana Landing](/images/monitoring/grafana-db-db.png)

In the Dashboards page, you can see 6 different dashboards which can be further customized or used as is:

![Grafana Landing](/images/monitoring/grafana-db-db2.png)

Click on each of them to see the detailed monitoring information. Note that some of the dashboards (e.g. Compute Node List, Compute Node Details) will not show any information until a job is launched (since we start with zero compute nodes in our cluster to save costs). 

- ParallelCluster Stats : This is the main dashboard that shows general monitoring info and metrics for the whole cluster. It includes Slurm metrics and Storage performance metrics.
![Grafana Landing](/images/monitoring/grafana-db-pc-stats.png)

- Master Node Details : This dashboard shows detailed metric for the Master node, including CPU, Memory, Network and Storage usage.
![Grafana Landing](/images/monitoring/grafana-db-master.png)

- Compute Node List : This dashboard show the list of the available compute nodes. Each entry is a link to a more detailed page.

- Compute Node Details : Similar to the master node details this dashboard show the same metric for the compute nodes.

- Cluster Logs : This dashboard shows all the logs of your HPC Cluster. The logs are pushed by AWS ParallelCluster to AWS ClowdWatch Logs and finally reported here.

- Cluster Costs : This dashboard shows the cost associated to every AWS Service utilized by your Cluster. It includes: EC2, EBS, FSx, S3, EFS. This is currently in beta
![Grafana Landing](/images/monitoring/grafana-db-cluster-cost.png)


 










