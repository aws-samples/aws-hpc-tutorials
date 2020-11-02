+++
title = "d. Review the Grafana Dashboards"
date = 2019-09-18T10:46:30-04:00
weight = 40
tags = ["tutorial", "Grafana", "ParallelCluster", "Monitoring", "Dashboards"]
+++

In this section, you will review the Grafana Monitoring Dashboard that's created as part of your cluster. 

### Grafana Dashboards

In the welcome page, click on the **Dashboards** button then select **Manage** as shown below

![Grafana Landing](/images/monitoring/grafana-db-db.png)

In the Dashboards page, you can see 6 different dashboards which can be further customized or used as is:

![Grafana Landing](/images/monitoring/grafana-db-db2.png)

Click on each of them to see the detailed monitoring information. Note that some of the dashboards (e.g. Compute Node List, Compute Node Details) will not show any information until a job is launched (since we start with zero compute nodes in our cluster to save costs). 

- **ParallelCluster Stats**: This is the main dashboard that shows general monitoring info and metrics for the whole cluster. It includes Slurm metrics and Storage performance metrics.
![Grafana Landing](/images/monitoring/grafana-db-pc-stats.png)

- **Master Node Details**: This dashboard shows detailed metric for the Master node, including CPU, Memory, Network and Storage usage.
![Grafana Landing](/images/monitoring/grafana-db-master.png)

- **Compute Node List**: This dashboard show the list of the available compute nodes. Each entry is a link to a more detailed page.

- **Compute Node Details**: Similar to the master node details this dashboard show the same metric for the compute nodes.

- **Cluster Logs**: This dashboard shows the logs of your HPC Cluster. The logs are pushed by AWS ParallelCluster to AWS ClowdWatch Logs and finally reported here.

- **Cluster Costs**: This dashboard shows the cost associated to every AWS Service utilized by your Cluster. It includes: EC2, EBS, FSx, S3, EFS. This is currently in beta
![Grafana Landing](/images/monitoring/grafana-db-cluster-cost.png)
