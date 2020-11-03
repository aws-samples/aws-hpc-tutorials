+++
title = "g. Troubleshooting"
date = 2019-09-18T10:46:30-04:00
weight = 200
tags = ["tutorial", "Grafana", "ParallelCluster", "Monitoring", "Dashboards"]
+++

During this lab you may encounter warnings and errors, solutions to the most common ones are shown here.

#### Self-signed certificate warning

The connection to the dashboards will go through HTTPs using a self-signed certificate. The warning below is displayed in Firefox. Click **Advanced...**, then **Accept the Risk and Continue**.

![self-signed warning](/images/monitoring/self-signed-warning.png)

#### Grafana produces an error 502

We noticed in some occasions that the Grafana container could not be fetched from DockerHub. A solution is to launch it manually on the head-node by running the command below. Replace `<HEAD_NODE_PUBLIC_IP>` by your head-node public IP and run the command in your terminal.


```bash
docker run --name grafana --net host -d --restart=unless-stopped -p 3000:3000 \
    -e GF_SECURITY_ADMIN_PASSWORD=Grafana4PC! \
    -e GF_SERVER_ROOT_URL="http://<HEAD_NODE_PUBLIC_IP>/grafana/" \
    -v /home/$cfn_cluster_user/grafana:/etc/grafana/provisioning \
    -v grafana-data:/var/lib/grafana \
    grafana/grafana
```
