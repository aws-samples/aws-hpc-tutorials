+++
title = "f. HPCG & IOR metrics"
date = 2019-09-18T10:46:30-04:00
weight = 80
tags = ["tutorial", "Grafana", "ParallelCluster", "Monitoring", "Dashboards"]
+++

In this section you will run the [High Performance Conjugate Gradients](https://www.hpcg-benchmark.org/) (HPCG) Benchmark used to represent the computational intensity of a broad range of applications. Then you will run the [IOR](https://ior.readthedocs.io/en/latest/) benchmark commonly used to evaluate storage performances on a system. The intent of this section is not to demonstrate the performances you can obtain on your system but visualize metrics for both applications. If you are interested in running IOR on Lustre with FSx for Lustre you will want to look at the [Storage Lab](/05-amazon-fsx-for-lustre.html)

### Install HPCG

1. First download and compile HPCG:
    ```bash
    wget https://aws-hpc-workshops.s3.amazonaws.com/install_grafana_benchmarks.sh
    bash install_grafana_benchmarks.sh
    ```

2. Next, create a submit file. You run over 8 nodes with a single core on each node. This establishes your baseline run:
    ```bash
    cat > hpcg.sbatch << EOF
    #!/bin/bash
    #SBATCH --job-name=hpcg-job
    #SBATCH --nodes=8
    #SBATCH --output=hpcg-run.out

    module load openmpi/4.0.3
    mpirun --report-bindings --map-by core ${HOME}/hpcg/bin/xhpcg --nx 128 --ny 128 --nz 128 --rt 200
    EOF
    ```

4. Submit the job and monitor the queue:
    ```bash
    sbatch hpcg.sbatch
    squeue -i 2
    ```

5. Once the job submitted it will be placed in a configuring state, noted **CF** in the `squeue` output. After a couple of minutes, the job will change to a running state, noted **R**.
![HPCG Submit](/images/monitoring/hpcg.png)


6. After the job completes, the HPCG output is stored in the `HPCG-Benchmark_3.1_2020-[date].txt` file that contains the timing information, scroll to the bottom and you'll see:

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

What are your observations when running HPCG? Look at the CPU usage, memory consumption  and network throughput. Did you take a look at a particular instance?

### Test with IOR

In the previous script we installed both **IOR** and **HPCG**. You will run both at the same time and see what the metrics tell you.

1. Start by creating submission script to run **IOR**:

    ```bash
    cd $HOME
    cat > ior.sbatch << EOF
    #!/bin/bash
    #SBATCH --job-name=ior-job
    #SBATCH --nodes=8
    #SBATCH --output=ior-run.out

    module load intelmpi
    mpirun ior -w -r -o=/shared/test_dir -b=256m -a=POSIX -i=5 -F -z -t=64m -C
    EOF
    ```

2. Then your job to run **IOR**

    ```bash
    sbatch ior.sbatch
    sbatch hpcg.sbatch
    squeue -i 2
    ```

3. After HPCG completes take a look at the timing file `HPCG-Benchmark_3.1_2020-[date].txt`:

    ```bash
    Final Summary::Reference version of ComputeDotProduct used=Performance results are most likely suboptimal
    Final Summary::Reference version of ComputeSPMV used=Performance results are most likely suboptimal
    Final Summary::Reference version of ComputeMG used=Performance results are most likely suboptimal
    Final Summary::Reference version of ComputeWAXPBY used=Performance results are most likely suboptimal
    Final Summary::Results are valid but execution time (sec) is=156.78
    Final Summary::Official results execution time (sec) must be at least=1800
    ```

4. You will notice run time is longer which is expected. Take a look at the **Compute Node Details** dashboard and you will see **IOR** stressed the network with spikes looking like.
![IOR Network](/images/monitoring/ior-network-traffic.png)

5. But did not stress the CPU:
![IOR CPU](/images/monitoring/ior-cpu-basic.png)

6. Now if you take a look at the metrics when you ran **HPCG** alone, you will observe a more of a constant load on the network with less spikiness.
![IOR Network](/images/monitoring/hpcg-bandwidth.png)

Did you take a look at the numbers of file descriptors opened when running IOR?
