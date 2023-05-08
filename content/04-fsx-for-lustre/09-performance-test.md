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
[ec2-user@ip-172-31-24-231 ~]$ ior
IOR-3.3.0+dev: MPI Coordinated Test of Parallel I/O
Began               : Wed Jun 22 23:56:26 2022
Command line        : ior
Machine             : Linux ip-172-31-24-231
TestID              : 0
StartTime           : Wed Jun 22 23:56:26 2022
Path                : /home/ec2-user
FS                  : 40.0 GiB   Used FS: 39.7%   Inodes: 20.0 Mi   Used Inodes: 1.4%

Options:
api                 : POSIX
apiVersion          :
test filename       : testFile
access              : single-shared-file
type                : independent
segments            : 1
ordering in a file  : sequential
ordering inter file : no tasks offsets
tasks               : 1
clients per node    : 1
repetitions         : 1
xfersize            : 262144 bytes
blocksize           : 1 MiB
aggregate filesize  : 1 MiB

Results:

access    bw(MiB/s)  block(KiB) xfer(KiB)  open(s)    wr/rd(s)   close(s)   total(s) iter
------    ---------  ---------- ---------  --------   --------   --------   -------- ----
write     3475.49    1024.00    256.00     0.000030   0.000253   0.000005   0.000288   0
read      12522      1024.00    256.00     0.000002   0.000077   0.000001   0.000080   0
remove    -          -          -          -          -          -          0.000080   0
Max Write: 3475.49 MiB/sec (3644.32 MB/sec)
Max Read:  12521.52 MiB/sec (13129.77 MB/sec)

Summary of all tests:
Operation   Max(MiB)   Min(MiB)  Mean(MiB)     StdDev   Max(OPs)   Min(OPs)  Mean(OPs)     StdDev    Mean(s) Stonewall(s) Stonewall(MiB) Test# #Tasks tPN reps fPP reord reordoff reordrand seed segcnt   blksiz    xsize aggs(MiB)   API RefNum
write        3475.49    3475.49    3475.49       0.00   13901.97   13901.97   13901.97       0.00    0.00029         NA            NA     0      1   1    1   0     0        1         0 0      1  1048576   262144       1.0 POSIX      0
read        12521.52   12521.52   12521.52       0.00   50086.08   50086.08   50086.08       0.00    0.00008         NA            NA     0      1   1    1   0     0        1         0 0      1  1048576   262144       1.0 POSIX      0
Finished            : Wed Jun 22 23:56:26 2022
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

The IOR output is written to **ior.out** file. If you want, you can use **tail -f ior.out** to view the file as it is written. However, remember that since you have `0` compute nodes present on your cluster, it may take up to 2 minutes for instances to be created then register with the cluster. You can check the status of the instances on the **Instances** tab in AWS ParallelCluster UI. After the instances are created and registered, the IOR job will go into state `R` running.

After the job completes, run `cat ior.out` and you should see a result similar to the following. In this example, you see 1 GB/s performance, which is not too far from the [720 MB/s](https://docs.aws.amazon.com/fsx/latest/LustreGuide/performance.html#fsx-aggregate-perf) offered by Amazon FSx for Lustre.

```bash
[ec2-user@ip-172-31-20-218 ior]$ cat ior.out 
Loading intelmpi version 2021.6.0
IOR-4.0.0rc2+dev: MPI Coordinated Test of Parallel I/O
Began               : Mon May  8 14:02:32 2023
Command line        : /shared/ior/bin/ior -w -r -o=/shared/test_dir -b=256m -a=POSIX -i=5 -F -z -t=64m -C
Machine             : Linux compute-dy-c5-1
TestID              : 0
StartTime           : Mon May  8 14:02:32 2023
Path                : /shared/test_dir.00000000
FS                  : 1.1 TiB   Used FS: 0.0%   Inodes: 6.0 Mi   Used Inodes: 0.0%

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
write     755.68     11.81      1.29        262144     65536      0.002836   5.42       0.279862   5.42       0   
read      423.03     6.61       2.40        262144     65536      0.000715   9.68       0.680220   9.68       0   
write     15082      236.34     0.065116    262144     65536      0.001898   0.270799   0.038727   0.271581   1   
read      262.34     4.10       3.82        262144     65536      0.000641   15.61      0.613482   15.61      1   
write     15224      238.41     0.062267    262144     65536      0.001985   0.268447   0.022290   0.269041   2   
read      215.14     3.36       4.71        262144     65536      0.000866   19.04      0.528298   19.04      2   
write     15205      238.14     0.065279    262144     65536      0.001824   0.268745   0.030591   0.269378   3   
read      225.72     3.53       4.44        262144     65536      0.000703   18.15      0.533358   18.15      3   
write     15310      239.86     0.062527    262144     65536      0.002259   0.266824   0.027244   0.267534   4   
read      219.79     3.43       4.61        262144     65536      0.000885   18.64      0.642154   18.64      4   

Summary of all tests:
Operation   Max(MiB)   Min(MiB)  Mean(MiB)     StdDev   Max(OPs)   Min(OPs)  Mean(OPs)     StdDev    Mean(s) Stonewall(s) Stonewall(MiB) Test# #Tasks tPN reps fPP reord reordoff reordrand seed segcnt   blksiz    xsize aggs(MiB)   API RefNum
write       15310.20     755.68   12315.56    5780.40     239.22      11.81     192.43      90.32    1.29957         NA            NA     0     16   4    5   1     1        1         0    0      1 268435456 67108864    4096.0 POSIX      0
read          423.03     215.14     269.20      78.70       6.61       3.36       4.21       1.23   16.22356         NA            NA     0     16   4    5   1     1        1         0    0      1 268435456 67108864    4096.0 POSIX      0
Finished            : Mon May  8 14:04:00 2023
```
