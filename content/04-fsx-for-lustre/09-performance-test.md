+++
title = "i. Test IO Performance"
date = 2019-09-18T10:46:30-04:00
weight = 90
tags = ["tutorial", "IOR", "FSx", "Performances"]
+++

In this step, you run performance tests with IOR and evaluate how much throughput can be extracted. To measure throughput, you tune several IOR parameters to favor POSIX as an IO access method and conduct direct access to the file system. This approach helps you bypass almost all caching and evaluate the raw performances of Amazon FSx for Lustre. Further, you generate one file per process to saturate the file system.

{{% notice info %}}
IOR is considered the standard tool in HPC to evaluate parallel file system performances, which makes it easy to compare results across systems. See also the [IO500 Benchmark](https://www.vi4io.org/std/io500/start). However, feel free to try other IO performance testing tools, such as [FIO](https://fio.readthedocs.io/en/latest/index.html) or [DD](https://www.unixtutorial.org/test-disk-speed-with-dd).
{{% /notice %}}
#### IOR Options

For this test, we will use these `ior` options `-w -r -o=/shared/test_dir -b=256m -a=POSIX -i=5 -F -z -t=64m -C`. The following table contains a description of the options used.


Option        | Description
------------- | -------------
**-w**        | Benchmark write performances.
**-r**        | Benchmark read performances.
**-o**        | Benchmark file output path. Defines the file system to benchmark.
**-a**        | Method to use, POSIX is selected for raw perfs. MPI-IO has data caching and skew the results.
**-i**        | Number of repetitions (use 5 as a good test, stdev should be minimal).
**-F**        | One file per process if present, shared file if not present. One file per process is the most intense.
**-z**        | Access is to random, not sequential, offsets within a file.
**-C**        | Reorder tasks: change the task ordering to N+1 ordering for readback. Clients will not read the data they just wrote.

{{% notice tip %}}
You can find the full list of options for IOR in the [IOR documentation](https://ior.readthedocs.io/en/latest/userDoc/options.html). 
Or print a short version of the ior options in the shell `ior --help`.
Do not hesitate to experiment with different parameters.
{{% /notice %}}

Verify that IOR is installed correctly by running the command `ior` in your terminal.

You should see a result similar to below. Don't be alarmed by the numbers as there's a lot of caching involved.

```bash
ior
```

```bash
<<<<<<< HEAD
[ec2-user@ip-172-31-25-220 ior]$ ior
IOR-4.0.0rc2+dev: MPI Coordinated Test of Parallel I/O
Began               : Tue May  9 12:14:07 2023
=======
[ec2-user@ip-172-31-24-231 ~]$ ior
IOR-3.3.0+dev: MPI Coordinated Test of Parallel I/O
Began               : Wed Jun 22 23:56:26 2022
>>>>>>> 5e3c9caf0acfe09f57a168811047d323cb8474bc
Command line        : ior
Machine             : Linux ip-172-31-25-220
TestID              : 0
StartTime           : Tue May  9 12:14:07 2023
Path                : testFile
FS                  : 1.1 TiB   Used FS: 0.0%   Inodes: 5.5 Mi   Used Inodes: 0.0%

Options:
api                 : POSIX
apiVersion          :
test filename       : testFile
access              : single-shared-file
type                : independent
segments            : 1
ordering in a file  : sequential
ordering inter file : no tasks offsets
nodes               : 1
tasks               : 1
clients per node    : 1
repetitions         : 1
xfersize            : 262144 bytes
blocksize           : 1 MiB
aggregate filesize  : 1 MiB

Results:

access    bw(MiB/s)  IOPS       Latency(s)  block(KiB) xfer(KiB)  open(s)    wr/rd(s)   close(s)   total(s)   iter
------    ---------  ----       ----------  ---------- ---------  --------   --------   --------   --------   ----
write     584.49     4094       0.000244    1024.00    256.00     0.000515   0.000977   0.000219   0.001711   0
read      2041.02    38836      0.000026    1024.00    256.00     0.000210   0.000103   0.000177   0.000490   0

Summary of all tests:
Operation   Max(MiB)   Min(MiB)  Mean(MiB)     StdDev   Max(OPs)   Min(OPs)  Mean(OPs)     StdDev    Mean(s) Stonewall(s) Stonewall(MiB) Test# #Tasks tPN reps fPP reord reordoff reordrand seed segcnt   blksiz    xsize aggs(MiB)   API RefNum
write         584.49     584.49     584.49       0.00    2337.96    2337.96    2337.96       0.00    0.00171         NA            NA     0      1   1    1   0     0        10    0      1  1048576   262144       1.0 POSIX      0
read         2041.02    2041.02    2041.02       0.00    8164.10    8164.10    8164.10       0.00    0.00049         NA            NA     0      1   1    1   0     0        10    0      1  1048576   262144       1.0 POSIX      0
Finished            : Tue May  9 12:14:07 2023
```

#### Run a Performance Test with IOR

In this step, you run your performance test using multiple nodes. In the following example, you use 8 c5.xlarge instances for a total of 32 processes. Each process writes 256 MB by blocks of 64 MB. You use the POSIX-IO method and directly access the file system to evaluate raw performances. The test is conducted 5 times to evaluate the variance, i.e. if performances are stable, for both read and write. You don't need to wait between read and writes because results will not differ.


First, generate your batch submission script by copy and pasting the following code into your AWS Cloud9 terminal. Make sure you are connected to your cluster master instance.


```bash
cat > ~/ior_submission.sbatch << EOF
#!/bin/bash
#SBATCH --job-name=ior
#SBATCH --ntasks=16
#SBATCH --output=%x.out

module load intelmpi
mpirun /shared/ior/bin/ior -w -r -o=/shared/test_dir -b=256m -a=POSIX -i=5 -F -z -t=64m -C
EOF
```

Then, submit the script with **sbatch** as follows.

```bash
sbatch ~/ior_submission.sbatch
```

Monitor the job's progress with `watch squeue` command

```bash
watch squeue
```
```
Every 2.0s: squeue                                                                                                                                                  Mon May  8 12:40:18 2023

             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                 1   compute      ior ec2-user  R       3:33      4 compute-dy-c5a-[1-4]
```

When the state (`ST`) is configuring (`CF`) wait until it becomes running (`R`).
Send the interrupt signal to the `watch` command by pressing `Ctrl+c` to stop it.

The IOR output is written to **ior.out** file. If you want, you can use **tail -f ior.out** to view the file as it is written. However, remember that since you have `0` compute nodes present on your cluster, it may take up to 2 minutes for instances to be created then register with the cluster. You can check the status of the instances on the **Instances** tab in AWS ParallelCluster UI. After the instances are created and registered, the IOR job will go into state `R` running.

After the job completes, run `cat ior.out` and you should see a result similar to the following. In this example, you see 1 GB/s performance, which is not too far from the [720 MB/s](https://docs.aws.amazon.com/fsx/latest/LustreGuide/performance.html#fsx-aggregate-perf) offered by Amazon FSx for Lustre.

```bash
[ec2-user@ip-172-31-25-220 ior]$ cat ior.outLoading intelmpi version 2021.6.0
IOR-4.0.0rc2+dev: MPI Coordinated Test of Parallel I/O
Began               : Tue May  9 12:14:39 2023
Command line        : /shared/ior/bin/ior -w -r -o=/shared/test_dir -b=256m -a=POSIX -i=5 -F -z -t=64m -C
Machine             : Linux compute-dy-c5-1
TestID              : 0
StartTime           : Tue May  9 12:14:39 2023
Path                : /shared/test_dir.00000000
FS                  : 1.1 TiB   Used FS: 0.0%   Inodes: 5.5 Mi   Used Inodes: 0.0%

Options: 
api                 : POSIX
apiVersion          : 
test filename       : /shared/test_dir
access              : file-per-process
type                : independent
segments            : 1
ordering in a file  : random
ordering inter file : constant task offset
task offset         : 1
nodes               : 4
tasks               : 16
clients per node    : 4
repetitions         : 5
xfersize            : 64 MiB
blocksize           : 256 MiB
aggregate filesize  : 4 GiB

Results: 

access    bw(MiB/s)  IOPS       Latency(s)  block(KiB) xfer(KiB)  open(s)    wr/rd(s)   close(s)   total(s)   iter
------    ---------  ----       ----------  ---------- ---------  --------   --------   --------   --------   ----
write     960.23     15.01      0.831487    262144     65536      0.002670   4.26       1.27       4.27       0
read      400.40     6.26       2.46        262144     65536      0.000770   10.23      1.03       10.23      0
write     972.67     15.20      0.899350    262144     65536      0.002018   4.21       1.61       4.21       1
read      395.37     6.18       2.54        262144     65536      0.000655   10.36      0.714747   10.36      1
write     963.26     15.05      0.903939    262144     65536      0.002298   4.25       1.09       4.25       2
read      385.05     6.02       2.57        262144     65536      0.000773   10.64      0.694684   10.64      2
write     929.10     14.52      1.09        262144     65536      0.002420   4.41       1.12       4.41       3
read      374.12     5.85       2.67        262144     65536      0.000867   10.95      0.596961   10.95      3
write     973.41     15.21      0.904936    262144     65536      0.002181   4.21       1.63       4.21       4
read      340.51     5.32       3.00        262144     65536      0.000805   12.03      3.04       12.03      4

Summary of all tests:
Operation   Max(MiB)   Min(MiB)  Mean(MiB)     StdDev   Max(OPs)   Min(OPs)  Mean(OPs)     StdDev    Mean(s) Stonewall(s) Stonewall(MiB) Test# #Tasks tPN reps fPP reord reordoff reordrand seed segcnt   blksiz    xsize aggs(MiB)   API RefNum
write         973.41     929.10     959.73      16.16      15.21      14.52      15.00       0.25    4.26909         NA            NA     0     16   4    5   1     1        10    0      1 268435456 67108864    4096.0 POSIX      0
read          400.40     340.51     379.09      21.30       6.26       5.32       5.92       0.33   10.84087         NA            NA     0     16   4    5   1     1        10    0      1 268435456 67108864    4096.0 POSIX      0
Finished            : Tue May  9 12:15:55 2023
```
