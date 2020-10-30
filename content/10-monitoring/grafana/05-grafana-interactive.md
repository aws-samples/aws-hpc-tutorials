+++
title = "d. Interactive Dashboard Monitoring"
date = 2019-09-18T10:46:30-04:00
weight = 150
tags = ["tutorial", "Grafana", "ParallelCluster", "Monitoring", "Dashboards", "Benchmark"]
+++

In this section, you will run a sample benchmark on the Cluster Head node and monitor the different metrics in the **Master Node Details** Dashboard


In the AWS Cloud9 terminal login to the head node of your cluster as below:

```bash
pcluster ssh perflab-yourname -i ~/.ssh/lab-4-key
```

Install the **stress-ng** tool. 

**stress-ng** is a stress test tool which is designed to exercise various physical subsystems of a computer system as well as various operating system kernel interfaces. 
The tool has over 240 stress tests including CPU, virtual memory and I/O specific stress tests. 

Install the **stress-ng** tool on the head node of your cluster as follows:

```bash
sudo yum -y install stress-ng
```

Now, lets run some stress tests using stress-ng and monitor the performance metrics in the Grafana Dashboard.

**Note**: Since you will be running these tests on the **Master Node**, you will look for the metrics in the **Master Node Details** Dashboard.


**CPU STRESS TEST**

- In you cluster Master node, start 4 workers exercising the CPU [spinning on sqrt(rand())]

```bash
stress-ng --cpu 4 --timeout 120s --metrics-brief
```
- Go back to the Grafana Dashboards in your browser and navigate to the **Master Node Details** Dashboard. The Master node is running on **c5.xlarge** which has 4 vCPUs. Since the cpu stress test is running for 2 mins (120 secs.) on 4 workers, the CPU utilization should be 100% for 120 secs in the timeline. 

- The **CPU Basic** in the dashboard should look like below:

![Grafana Stress CPU](/images/monitoring/grafana-master-stress-cpu.png)


**MEMORY STRESS TEST**

- Now, let us stress the memory. Use mmap N bytes per VM worker. You can specify the size as % of total available memory or in units on Bytes, KBytes, MBytes and GBytes using the suffix b, k, m or g:

```bash
stress-ng --vm 4 --vm-bytes 1G --timeout 120s --metrics-brief
```

- The **--vm 4** will start 4 workers continuosly calling mmap/munmap and writing to the allocated memory. 

- The **Memory Basic** in the dashboard should show the utilization of 4GB of physical memory for 2mins (120 secs.) as below:

![Grafana Stress Memory](/images/monitoring/grafana-master-stress-memory.png)


**DISK I/O STRESS TEST**
- Run a simple directory thrashing stress test as below:

```bash
stress-ng --dir 4 --timeout 120 --metrics-brief
```

- This starts 4 directory thrashing stressors, writing to the disk. You should see the write bandwidth go high in the **Disk R/W Data** dashboard as below:

![Grafana Stress Disk](/images/monitoring/grafana-master-stress-disk.png)

**PUTTING IT ALL TOGETHER**
- Run for 120 secs with 2 cpu stressors, 1 dir stressor and 1 vm stressor using 1GB of virtual memory

```bash
stress-ng --cpu 2 --dir 1 --vm 1 --vm-bytes 1G --timeout 120 --metrics-brief
```

![Grafana Stress Disk](/images/monitoring/grafana-master-stress-all.png)






 










