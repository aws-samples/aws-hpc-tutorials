---
title: "e. EFA NCCL Test"
weight: 35
tags: ["tutorial", "ParallelCluster", "nccl", "efa"]
---

We're going to run the [nccl-tests](https://github.com/NVIDIA/nccl-tests) (this was installed during AMI creation in `/tmp/nccl-tests`) and check to make sure NCCL, and EFA are setup. This also serves as an explanation of how to submit jobs to Slurm.

1. Create a file `nccl-efa-tests.sh` with the following:

    ```bash
    #!/bin/bash

    #SBATCH --job-name=nccl-tests
    #SBATCH --nodes=2
    #SBATCH --tasks-per-node=8
    #SBATCH --cpus-per-task=12
    #SBATCH --output=%x_%j.out

    # Load libraries
    export 
    LD_LIBRARY_PATH=/opt/nccl/build/lib:/usr/local/cuda/lib64:/opt/amazon/efa/lib64:/opt/amazon/openmpi/lib64:/opt/aws-ofi-nccl/lib:$LD_LIBRARY_PATH

    # EFA configurations
    export FI_PROVIDER=efa
    export FI_EFA_USE_DEVICE_RDMA=1

    # NCCL configurations
    export NCCL_DEBUG=info
    export NCCL_PROTO=simple
    export NCCL_BUFFSIZE=33554432
    export NCCL_ALGO=ring

    # Run nccl-tests all reduce perf benchmark
    module load openmpi
    mpirun -n $SLURM_NTASKS -N $SLURM_JOB_NUM_NODES -x NCCL_BUFFSIZE=33554432 --map-by ppr:8:node --rank-by slot \
        --mca pml ^cm --mca btl tcp,self --mca btl_tcp_if_exclude lo,docker0 --bind-to none \
        /tmp/nccl-tests/build/all_reduce_perf -b 8 -e 2G -f 2 -g 1 -c 1 -n 100
    ```

    | Slurm Flag           | Description                                                  |
    |----------------------|--------------------------------------------------------------|
    | `--nodes=2`          | Run on two nodes                                             |
    | `--tasks-per-node=8` | Run on 8 processes per node                                  |
    | `--cpus-per-task=12` | Run on 12 cpus per process, for a total of 8 * 12 = 96 vcpus |

2. Submit the job

    ```bash
    sbatch nccl-efa-tests.sh
    watch squeue # wait for job to go into 'R' running
    ```

3. After the job has completed, take a look at the output file:

    ```sbatch
    cat nccl-tests_2.out
    ```

At the bottom of the file, you'll see the results of the NCCL traffic tests.

```
compute-dy-g4dn-1:15351:15351 [0] NCCL INFO Launch mode Parallel
           8             2     float     sum      -1    55.02    0.00    0.00      0    55.46    0.00    0.00      0
          16             4     float     sum      -1    54.06    0.00    0.00      0    53.81    0.00    0.00      0
          32             8     float     sum      -1    54.44    0.00    0.00      0    53.67    0.00    0.00      0
          64            16     float     sum      -1    54.58    0.00    0.00      0    53.77    0.00    0.00      0
         128            32     float     sum      -1    55.10    0.00    0.00      0    54.45    0.00    0.00      0
         256            64     float     sum      -1    55.32    0.00    0.01      0    54.72    0.00    0.01      0
         512           128     float     sum      -1    55.82    0.01    0.02      0    55.17    0.01    0.02      0
        1024           256     float     sum      -1    56.55    0.02    0.03      0    55.37    0.02    0.03      0
        2048           512     float     sum      -1    59.01    0.03    0.06      0    58.37    0.04    0.06      0
        4096          1024     float     sum      -1    60.91    0.07    0.12      0    60.66    0.07    0.12      0
        8192          2048     float     sum      -1    63.56    0.13    0.23      0    63.43    0.13    0.23      0
       16384          4096     float     sum      -1    68.21    0.24    0.42      0    68.12    0.24    0.42      0
       32768          8192     float     sum      -1    77.48    0.42    0.74      0    77.56    0.42    0.74      0
       65536         16384     float     sum      -1    87.36    0.75    1.31      0    87.43    0.75    1.31      0
      131072         32768     float     sum      -1    116.8    1.12    1.96      0    116.7    1.12    1.96      0
      262144         65536     float     sum      -1    164.1    1.60    2.80      0    163.7    1.60    2.80      0
      524288        131072     float     sum      -1    248.3    2.11    3.70      0    247.9    2.11    3.70      0
     1048576        262144     float     sum      -1    422.1    2.48    4.35      0    421.9    2.49    4.35      0
     2097152        524288     float     sum      -1    770.2    2.72    4.77      0    767.2    2.73    4.78      0
     4194304       1048576     float     sum      -1   1460.6    2.87    5.03      0   1460.9    2.87    5.02      0
     8388608       2097152     float     sum      -1   2802.7    2.99    5.24      0   2803.6    2.99    5.24      0
    16777216       4194304     float     sum      -1   5555.3    3.02    5.29      0   5553.1    3.02    5.29      0
    33554432       8388608     float     sum      -1    11061    3.03    5.31      0    11062    3.03    5.31      0
    67108864      16777216     float     sum      -1    22090    3.04    5.32      0    22084    3.04    5.32      0
   134217728      33554432     float     sum      -1    44123    3.04    5.32      0    44129    3.04    5.32      0
   268435456      67108864     float     sum      -1    88195    3.04    5.33      0    88183    3.04    5.33      0
   536870912     134217728     float     sum      -1   176380    3.04    5.33      0   176388    3.04    5.33      0
  1073741824     268435456     float     sum      -1   352670    3.04    5.33      0   352679    3.04    5.33      0
  2147483648     536870912     float     sum      -1   705156    3.05    5.33      0   705133    3.05    5.33      0
compute-dy-g4dn-1:15358:15358 [7] NCCL INFO comm 0x7f06f4000f60 rank 7 nranks 8 cudaDev 7 busId f5000 - Destroy COMPLETE
compute-dy-g4dn-1:15351:15351 [0] NCCL INFO comm 0x7f8958000f60 rank 0 nranks 8 cudaDev 0 busId 18000 - Destroy COMPLETE
# Out of bounds values : 0 OK
# Avg bus bandwidth    : 2.52874
#
compute-dy-g4dn-1:15355:15355 [4] NCCL INFO comm 0x7f86bc000f60 rank 4 nranks 8 cudaDev 4 busId e7000 - Destroy COMPLETE
compute-dy-g4dn-1:15353:15353 [2] NCCL INFO comm 0x7f5184000f60 rank 2 nranks 8 cudaDev 2 busId 35000 - Destroy COMPLETE
compute-dy-g4dn-1:15356:15356 [5] NCCL INFO comm 0x7fbd28000f60 rank 5 nranks 8 cudaDev 5 busId e8000 - Destroy COMPLETE
compute-dy-g4dn-1:15357:15357 [6] NCCL INFO comm 0x7fef90000f60 rank 6 nranks 8 cudaDev 6 busId f4000 - Destroy COMPLETE
compute-dy-g4dn-1:15354:15354 [3] NCCL INFO comm 0x7f2b7c000f60 rank 3 nranks 8 cudaDev 3 busId 36000 - Destroy COMPLETE
compute-dy-g4dn-1:15352:15352 [1] NCCL INFO comm 0x7f05e8000f60 rank 1 nranks 8 cudaDev 1 busId 19000 - Destroy COMPLETE
```

You'll see the NCCL