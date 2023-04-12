---
title: "e. Download, compile and run the NCCL tests"
date: 2020-05-12T13:27:03Z
weight : 40
tags : ["tutorial", "EFA", "ec2", "NCCL", "MPI", "Benchmark", "compile"]
---



In this section, you will download, compile and run on 2 nodes a common GPU to GPU communication benchmarks from Nvidia used in ML Frameworks such as PyTorch.


#### Download and Compile the NCCL tests

You can run the script below on the Master node of your ParallelCluster in the home directory to 

```bash
cd ~

cat > compile_nccl.sh << EOF
#!/bin/bash

module load intelmpi

git clone -b v2.17.1-1 https://github.com/NVIDIA/nccl.git
cd nccl
make -j src.build CUDA_HOME=/usr/local/cuda NVCC_GENCODE='-gencode=arch=compute_70,code=sm_70 -gencode=arch=compute_75,code=sm_75 -gencode=arch=compute_80,code=sm_80'
cd ..

git clone -b aws https://github.com/aws/aws-ofi-nccl.git
cd aws-ofi-nccl
./autogen.sh
./configure --prefix=${HOME}/aws-ofi-nccl/install --with-mpi=/opt/amazon/openmpi --with-libfabric=/opt/amazon/efa --with-cuda=/usr/local/cuda
make
make install
cd ..

git clone -b v2.13.6 https://github.com/NVIDIA/nccl-tests.git
cd nccl-tests
make MPI=1 CUDA_HOME=/usr/local/cuda MPI_HOME=/opt/amazon/openmpi NCCL_HOME=${HOME}/nccl/build

echo "Installation done, run a quick test!"
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${HOME}/nccl/build/lib:${HOME}/aws-ofi-nccl/install/lib
/opt/amazon/openmpi/bin/mpirun -np 8 ./build/all_reduce_perf -b 8 -e 128M -f 2 -g 1

EOF

sh ./compile_nccl.sh
```


#### Submit NCCL benchmark

Create your job submission script for *OSU Latency* and use **sbatch** to submit your job:

```bash
cat > nccl_test.sbatch << \EOF
#!/bin/bash
#SBATCH -n 192
#SBATCH -N 2
#SBATCH --gres=gpu:8
#SBATCH --output=nccl.out

NCCL_TEST_PATH=${HOME}/nccl-tests/build
MPI_PATH=/opt/amazon/openmpi

export LD_LIBRARY_PATH=${HOME}/nccl/build/lib:${HOME}/aws-ofi-nccl/install/lib

export NCCL_PROTO=simple
export FI_EFA_USE_DEVICE_RDMA=1 # use for P4
export FI_EFA_FORK_SAFE=1
export FI_PROVIDER=efa
export FI_EFA_ENABLE_SHM_TRANSFER=0

export NCCL_DEBUG=INFO
export FI_LOG_LEVEL=1

${MPI_PATH}/bin/mpirun --map-by ppr:8:node --rank-by slot \
                     --mca pml ^cm  --mca btl tcp,self \
                     --mca btl_tcp_if_exclude lo,docker0 --bind-to none \
                     ${NCCL_TEST_PATH}/all_reduce_perf -b 8 -e 9G -f 2 -g 1 -c 1 -n 100
EOF

sbatch nccl_test.sbatch
watch squeue
```

You have to wait a couple of minutes for your compute instances to come up, once you see the job go from **PD** pending to **R** running state, you know the instances are up. Type **Ctrl-C** to exit squeue at any point.

After the job has completed, find the output in `cat ~/nccl.out` . You will see something like:

```bash
$ head -n 19 ~/nccl.out
# nThread 1 nGpus 1 minBytes 8 maxBytes 9663676416 step: 2(factor) warmup iters: 5 iters: 100 agg iters: 1 validation: 1 graph: 0
#
# Using devices
#  Rank  0 Group  0 Pid  77208 on new-st-gpu-1 device  0 [0x10] NVIDIA A100-SXM4-80GB
#  Rank  1 Group  0 Pid  77209 on new-st-gpu-1 device  1 [0x10] NVIDIA A100-SXM4-80GB
#  Rank  2 Group  0 Pid  77211 on new-st-gpu-1 device  2 [0x20] NVIDIA A100-SXM4-80GB
#  Rank  3 Group  0 Pid  77212 on new-st-gpu-1 device  3 [0x20] NVIDIA A100-SXM4-80GB
#  Rank  4 Group  0 Pid  77213 on new-st-gpu-1 device  4 [0x90] NVIDIA A100-SXM4-80GB
#  Rank  5 Group  0 Pid  77214 on new-st-gpu-1 device  5 [0x90] NVIDIA A100-SXM4-80GB
#  Rank  6 Group  0 Pid  77215 on new-st-gpu-1 device  6 [0xa0] NVIDIA A100-SXM4-80GB
#  Rank  7 Group  0 Pid  77216 on new-st-gpu-1 device  7 [0xa0] NVIDIA A100-SXM4-80GB
#  Rank  8 Group  0 Pid  95401 on new-st-gpu-2 device  0 [0x10] NVIDIA A100-SXM4-80GB
#  Rank  9 Group  0 Pid  95402 on new-st-gpu-2 device  1 [0x10] NVIDIA A100-SXM4-80GB
#  Rank 10 Group  0 Pid  95403 on new-st-gpu-2 device  2 [0x20] NVIDIA A100-SXM4-80GB
#  Rank 11 Group  0 Pid  95404 on new-st-gpu-2 device  3 [0x20] NVIDIA A100-SXM4-80GB
#  Rank 12 Group  0 Pid  95405 on new-st-gpu-2 device  4 [0x90] NVIDIA A100-SXM4-80GB
#  Rank 13 Group  0 Pid  95406 on new-st-gpu-2 device  5 [0x90] NVIDIA A100-SXM4-80GB
#  Rank 14 Group  0 Pid  95407 on new-st-gpu-2 device  6 [0xa0] NVIDIA A100-SXM4-80GB
#  Rank 15 Group  0 Pid  95408 on new-st-gpu-2 device  7 [0xa0] NVIDIA A100-SXM4-80GB
```
This tells us we have 16 GPUs (one rank is one GPU) and 2 nodes in the job.


We can check if EFA is indeed used. You should see these parts of text:
```bash
cat nccl.out

....

new-st-gpu-2:8802:8863 [5] NCCL INFO NET/OFI Using aws-ofi-nccl 1.5.0aws
new-st-gpu-2:8802:8863 [5] NCCL INFO NET/OFI Configuring AWS-specific options

...

new-st-gpu-2:8804:8862 [6] NCCL INFO NET/OFI Selected Provider is efa (found 4 nics)
new-st-gpu-2:8804:8862 [6] NCCL INFO Using network AWS Libfabric
....

```

Alternatively we could check counter:
```bash
cat /sys/class/infiniband/rdmap*/ports/1/hw_counters/rx_bytes
```
for read bytes (this counter should be bigger after test) - see full [workshop](https://catalog.us-east-1.prod.workshops.aws/workshops/5563d004-a892-4c83-8d82-d8fa6baa0517/en-US/monitor) for more details.
`rdmap*` is for P4 instances, you will see other names (`efa_0` for example) in other instance types.


We can check end of the result file (`~/nccl.out` set in `~nccl_test.sbatch` as `#SBATCH --output=nccl.out` - you can also see it as `StdOut` in `scontrol show job ${YOUR_JOB_ID}`) like:
```bash
tail -n 60 nccl.out
#
#                                                              out-of-place                       in-place          
#       size         count      type   redop    root     time   algbw   busbw #wrong     time   algbw   busbw #wrong
#        (B)    (elements)                               (us)  (GB/s)  (GB/s)            (us)  (GB/s)  (GB/s)       
           8             2     float     sum      -1    174.2    0.00    0.00      0    171.7    0.00    0.00      0
          16             4     float     sum      -1    171.1    0.00    0.00      0    167.0    0.00    0.00      0
          32             8     float     sum      -1    162.4    0.00    0.00      0    158.1    0.00    0.00      0
          64            16     float     sum      -1    157.9    0.00    0.00      0    157.9    0.00    0.00      0
         128            32     float     sum      -1    158.7    0.00    0.00      0    158.3    0.00    0.00      0
         256            64     float     sum      -1    158.7    0.00    0.00      0    158.7    0.00    0.00      0
         512           128     float     sum      -1    158.7    0.00    0.01      0    159.1    0.00    0.01      0
        1024           256     float     sum      -1    161.3    0.01    0.01      0    161.4    0.01    0.01      0
        2048           512     float     sum      -1    176.5    0.01    0.02      0    175.7    0.01    0.02      0
        4096          1024     float     sum      -1    165.7    0.02    0.05      0    165.7    0.02    0.05      0
        8192          2048     float     sum      -1    172.1    0.05    0.09      0    171.5    0.05    0.09      0
       16384          4096     float     sum      -1    189.9    0.09    0.16      0    189.0    0.09    0.16      0
       32768          8192     float     sum      -1    220.4    0.15    0.28      0    218.2    0.15    0.28      0
       65536         16384     float     sum      -1    224.0    0.29    0.55      0    221.0    0.30    0.56      0
      131072         32768     float     sum      -1    227.3    0.58    1.08      0    223.3    0.59    1.10      0
      262144         65536     float     sum      -1    234.2    1.12    2.10      0    233.2    1.12    2.11      0
      524288        131072     float     sum      -1    257.4    2.04    3.82      0    257.3    2.04    3.82      0
     1048576        262144     float     sum      -1    307.4    3.41    6.40      0    306.7    3.42    6.41      0
     2097152        524288     float     sum      -1    388.3    5.40   10.13      0    388.7    5.40   10.12      0
     4194304       1048576     float     sum      -1    522.7    8.02   15.04      0    521.6    8.04   15.08      0
     8388608       2097152     float     sum      -1    761.2   11.02   20.66      0    757.8   11.07   20.75      0
    16777216       4194304     float     sum      -1   1200.2   13.98   26.21      0   1195.9   14.03   26.30      0
    33554432       8388608     float     sum      -1   1565.5   21.43   40.19      0   1559.6   21.52   40.34      0
    67108864      16777216     float     sum      -1   2724.5   24.63   46.18      0   2727.9   24.60   46.13      0
   134217728      33554432     float     sum      -1   4071.8   32.96   61.80      0   4070.3   32.98   61.83      0
   268435456      67108864     float     sum      -1   7390.4   36.32   68.10      0   7387.7   36.34   68.13      0
   536870912     134217728     float     sum      -1    13605   39.46   73.99      0    13594   39.49   74.05      0
  1073741824     268435456     float     sum      -1    25940   41.39   77.61      0    25985   41.32   77.48      0
```
