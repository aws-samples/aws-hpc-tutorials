+++
title = "f. Performance Bottlenecks"
date = 2019-09-18T10:46:30-04:00
weight = 80
tags = ["tutorial", "Grafana", "ParallelCluster", "Monitoring", "Dashboards"]
+++

In this section you run [High Performance Conjugate Gradients](https://www.hpcg-benchmark.org/) (HPCG) Benchmark, a benchmark that stresses CPU and memory access patterns of the cluster. The first run will be used to establish a baseline performance target, then on the second run you add in another benchmark that stresses a different part of the system and review the monitoring dashboard to find the bottleneck.

### Install HPCG

First download and compile HPCG:

```bash
wget https://aws-hpc-workshops.s3.amazonaws.com/install_grafana_benchmarks.sh
bash install_grafana_benchmarks.sh
```

Next, we'll create a submit file. You run over 8 nodes with a single core on each node. This establishes our baseline run:

```bash
cat > hpcg.sbatch << EOF
#!/bin/bash
#SBATCH --job-name=hpcg-job
#SBATCH --ntasks-per-node=1
#SBATCH --nodes=8
#SBATCH --output=hpcg-run.out

module load openmpi/4.0.3
mpirun --report-bindings --map-by core ${HOME}/hpcg/bin/xhpcg --nx 128 --ny 128 --nz 128 --rt 200
EOF
```

Submit the job and monitor the queue:

```bash
sbatch hpcg.sbatch
squeue -i 2
```

First it'll go into **CF**, configuring, state. After about 3 minutes it'll go into **R**, running, state.

![HPCG Submit](/images/monitoring/hpcg.png)

After it completes review the timing information in `HPCG-Benchmark_3.1_2020-[date].txt`. It'll look like this:

```txt
Final Summary::HPCG result is VALID with a GFLOP/s rating of=9.48102
Final Summary::HPCG 2.4 rating for historical reasons is=9.75306
Final Summary::Reference version of ComputeDotProduct used=Performance results are most likely suboptimal
Final Summary::Reference version of ComputeSPMV used=Performance results are most likely suboptimal
Final Summary::Reference version of ComputeMG used=Performance results are most likely suboptimal
Final Summary::Reference version of ComputeWAXPBY used=Performance results are most likely suboptimal
Final Summary::Results are valid but execution time (sec) is=160.038
Final Summary::Official results execution time (sec) must be at least=1800
```

Take note of `execution time (sec) is=160.038`.

### Test with IOR

In the previous script we installed two benchmarks, HPCG to stress the compute and network, and also IOR to stress the filesystem. What happens when we run them both?

To test that, first create a submit script:

```bash
cd $HOME
cat > ior.sbatch << EOF
#!/bin/bash
#SBATCH --job-name=ior-job
#SBATCH --ntasks-per-node=1
#SBATCH --nodes=8
#SBATCH --output=ior-run.out

module load intelmpi
mpirun ior -w -r -o=/shared/test_dir -b=256m -a=POSIX -i=5 -F -z -t=64m -C
EOF
```

Then submit both **HPCG** and **IOR**

```bash
sbatch hpcg.sbatch
sbatch ior.sbatch
squeue -i 2
```

After HPCG completes take a look at the timing file `HPCG-Benchmark_3.1_2020-[date].txt`:

```bash
Final Summary::Reference version of ComputeDotProduct used=Performance results are most likely suboptimal
Final Summary::Reference version of ComputeSPMV used=Performance results are most likely suboptimal
Final Summary::Reference version of ComputeMG used=Performance results are most likely suboptimal
Final Summary::Reference version of ComputeWAXPBY used=Performance results are most likely suboptimal
Final Summary::Results are valid but execution time (sec) is=240.78
Final Summary::Official results execution time (sec) must be at least=1800
```

You'll notice run time is longer. To diagnose the cause, take a look at the **Compute Node Details** Dashboard. 

![Compute Node Details](/images/monitoring/hpcg-load.png)