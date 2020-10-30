+++
title = "e. Slurm Job Monitoring"
date = 2019-09-18T10:46:30-04:00
weight = 200
tags = ["tutorial", "Grafana", "ParallelCluster", "Monitoring", "Dashboards", "Slurm"]
+++

In this section, you will run a few Slurm jobs on the Cluster Head node and monitor the different job metrics in the **ParallelCluster Stats** Dashboard

- In the AWS Cloud9 terminal login to the head node of your cluster as below:

```bash
pcluster ssh perflab-yourname -i ~/.ssh/lab-4-key
```


- Create an example Slurm job script as follows:

```bash
cat > job1.sh << EOF
> #!/bin/bash
> 
> #SBATCH --output=slurm-%j.out
> #SBATCH --nodes=2
> #SBATCH --time=10:00
> srun hostname
> srun sleep 60
> EOF

```

- Submit the script to SLURM using the SBATCH command as follows:

```bash
sbatch job1.sh
```

- Go back to the Grafana Dashboards in your browser and navigate to the **ParallelCluster Stats** Dashboard. You can navigate between the  different Dashboards as shown:
![Grafana Slurm Stats](/images/monitoring/grafana-slurm-stats-nav.png)

- Since we started with zero compute nodes in our cluster, it will take a few minutes to configure the compute nodes and start the job. 

- You can monitor the start time of the job in the **Scheduler Stats** panel of the **ParallelCluster Stats** Dashboard. This indicates how many Slurm Jobs are Running and/or Pending and when a job entered the "Running" state. 

![Grafana Slurm Stats](/images/monitoring/grafana-slurm-stats-1.png)

- The **Nodes** panel indicates the state of the Compute Nodes. In the above example we submitted a job requesting 2 Compute Nodes. The cluster we created can scale upto 8 Compute Nodes (as specified in the ParallelCluster config file). Thus we see 2 **Allocated Nodes** and 6 **Idle Nodes** when the job was running. 

![Grafana Slurm Stats](/images/monitoring/grafana-slurm-stats-2.png)








 










