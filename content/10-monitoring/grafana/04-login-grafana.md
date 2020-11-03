+++
title = "c. Login"
date = 2019-09-18T10:46:30-04:00
weight = 30
tags = ["tutorial", "Grafana", "ParallelCluster", "Monitoring", "Dashboards"]
+++

After your cluster is created, you can open a web-browser and connect to head node of your cluster using its public ip. A landing page will be presented to you with links to the Prometheus database service and the Grafana dashboards.

### Login

To get the public ip of the head node of your cluster using the **pcluster status** command as follows:

```bash
pcluster status perflab-yourname
```

You should see an output similar to the one shown below

![ParallelCluster Status](/images/monitoring/pcluster_status.png)


Open a browser (e.g. Chrome or Firefox) and connect to the head node of your cluster using the public ip address `https://PUBLIC_IP`. Click on **GRAFANA DASHBOARDS** on the landing page as shown below:

![Grafana Landing](/images/monitoring/grafana_login.png)


Login to the Grafana dashboards using the below username and password

|   Field       |  Value       |
|---------------|--------------|
| **username**: | `admin`      |
| **Password**: | `Grafana4PC!`|

{{% notice note %}}
If you modified the username or password in the post_install script when deploying the cluster, use the updated credentials.
{{% /notice %}}

![Grafana Landing](/images/monitoring/grafana-db-login.png)
