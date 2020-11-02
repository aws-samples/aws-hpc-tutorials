+++
title = "e. Compute Nodes Monitoring"
date = 2019-09-18T10:46:30-04:00
weight = 60
tags = ["tutorial", "Grafana", "ParallelCluster", "Monitoring", "Dashboards"]
+++

In this section, you will run a Slurm MPI job on the Cluster Head node and monitor the Compute Node job metrics in the **Compute Node Details** Dashboard

- In the AWS Cloud9 terminal login to the head node of your cluster as below:

```bash
pcluster ssh perflab-yourname -i ~/.ssh/lab-4-key
```

- Create an example Slurm MPI job script as shown below. The job runs a simple MPI Uni-directional network bandwidth test on 2 Compute Nodes from the Intel MPI Benchmark suite.

```bash
cat > job2.sh << EOF
#!/bin/bash
#SBATCH --output=slurm-%j.out
#SBATCH --nodes=2
#SBATCH --time=10:00

 module load intelmpi
 export I_MPI_DEBUG=5

 nodes=2
 ppn=2
 procs=$(( ppn * nodes ))
 
 echo "ppn = $ppn, Procs = $procs"
 
 mpirun -np $procs -ppn $ppn IMB-MPI1 Uniband -npmin $procs 
EOF
```

- Submit the script to SLURM using the SBATCH command as follows:

```bash
sbatch job2.sh
```


- Go back to the Grafana Dashboards in your browser and navigate to the **ParallelCluster Stats** Dashboard. Once the job is in Running state, switch to the **Compute Node List** dashboard. You should see 2 Compute Nodes allocated (since the Slurm MPI job requested for 2 nodes). 
![Grafana Compute Stats](/images/monitoring/grafana-compute-node-list.png)


- Now, navigate to the **Compute Node Details** Dashboard. Since we ran a network bandwidth test on 2 compute nodes, we monitor the network traffic on both compute nodes.
  
  **Note**: We are running on c5.large compute nodes which can deliver a network bandwidth of upto 10 Gbps. This is also evident from the dashboard stats below

![Grafana Compute Stats](/images/monitoring/grafana-compute-node-details-1.png)


![Grafana Compute Stats](/images/monitoring/grafana-compute-node-details-2.png)










 










