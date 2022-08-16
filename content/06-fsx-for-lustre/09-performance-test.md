+++
title = "i. Test IO Performance"
date = 2019-09-18T10:46:30-04:00
weight = 90
tags = ["tutorial", "IOR", "FSx", "Performances"]
+++

In this step, you run performance tests with IOR and evaluate how much throughput can be extracted. To measure throughput, you tune several IOR parameters to favor POSIX as an IO access method and conduct direct access to the file system. This approach helps you bypass almost all caching and evaluate the raw performances of Amazon FSx for Lustre. Further, you generate one file per process to saturate the file system.

#### IOR Options

For this test, you use the options listed in the following table.


Option        | Description
------------- | -------------
**-w**        | Benchmark write performances.
**-r**        | Benchmark read performances.
**-B**        | Use O_DIRECT to bypass the glibc caching layer and reach the OS and file system directly.
**-o**        | Benchmark file output path.
**-a**        | Method to use, POSIX is selected for raw perfs. MPI-IO has data caching and skew the results.
**-F**        | One file per process if present, shared file if not present. One file per process is the most intense.
**-Z**        | Changes task ordering to random ordering for readback.
**-z**        | Access is to random, not sequential, offsets within a file.
**-i**        | Number of repetitions (use 5 as a good test, stdev should be minimal).
**-C**        | Reorder tasks: change the task ordering to N+1 ordering for readback. Clients will not read the data they just wrote.

{{% notice tip %}}
You can find the full list of options for IOR in the [IOR documentation](https://ior.readthedocs.io/en/latest/userDoc/options.html). Do not hesitate to experiment with different parameters.
{{% /notice %}}

Verify that IOR is installed correctly by running the command `ior` in your terminal.

You should see a result similar to below. Don't be alarmed by the numbers as there's a lot of caching involved.

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
# go to your home directory
cd ~
cat > ior_submission.sbatch << EOF
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
# go to home again
cd ~
sbatch ior_submission.sbatch
```

Monitor the job's progress with `watch squeue` command

```bash
$ watch squeue
Every 2.0s: squeue                                                                                                                                                 Thu Jun 23 00:03:48 2022

             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                 2   compute      ior ec2-user  R       0:10      1 compute-dy-hpc6a-1
```

The IOR output is written to **ior.out** file. If you want, you can use **tail -f ior.out** to view the file as it is written. However, remember that since you have `0` compute nodes present on your cluster, it may take up to 2 minutes for instances to be created then register with the cluster. You can check the status of the instances on the **Instances** tab in pcluster manager. After the instances are created and registered, the IOR job will go into state `R` running.

After the job completes, run `cat ior.out` and you should see a result similar to the following. In this example, you see 1 GB/s performance, which is not too far from the [720 MB/s](https://docs.aws.amazon.com/fsx/latest/LustreGuide/performance.html#fsx-aggregate-perf) offered by Amazon FSx for Lustre.

```bash
$ cat ior.out
Loading intelmpi version 2021.4.0
IOR-3.3.0+dev: MPI Coordinated Test of Parallel I/O
Began               : Thu Jun 23 00:03:41 2022
Command line        : /shared/ior/bin/ior -w -r -o=/shared/test_dir -b=256m -a=POSIX -i=5 -F -z -t=64m -C
Machine             : Linux compute-dy-hpc6a-1
TestID              : 0
StartTime           : Thu Jun 23 00:03:41 2022
Path                : /shared
FS                  : 1.1 TiB   Used FS: 0.1%   Inodes: 1.9 Mi   Used Inodes: 1.9%

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
tasks               : 16
clients per node    : 16
repetitions         : 5
xfersize            : 64 MiB
blocksize           : 256 MiB
aggregate filesize  : 4 GiB

Results:

access    bw(MiB/s)  block(KiB) xfer(KiB)  open(s)    wr/rd(s)   close(s)   total(s) iter
------    ---------  ---------- ---------  --------   --------   --------   -------- ----
write     514.45     262144     65536      0.005846   7.96       2.01       7.96       0
read      1319.82    262144     65536      0.000905   3.10       2.99       3.10       0
remove    -          -          -          -          -          -          0.137179   0
write     515.45     262144     65536      0.004289   7.95       1.82       7.95       1
read      19418      262144     65536      0.000896   0.210461   0.010991   0.210942   1
remove    -          -          -          -          -          -          0.706001   1
write     531.41     262144     65536      0.004306   7.71       1.86       7.71       2
read      991.89     262144     65536      0.000917   4.13       4.06       4.13       2
remove    -          -          -          -          -          -          0.248080   2
write     501.92     262144     65536      0.004153   8.16       2.15       8.16       3
read      1105.77    262144     65536      0.001173   3.70       3.66       3.70       3
remove    -          -          -          -          -          -          0.242323   3
write     517.75     262144     65536      0.004291   7.91       1.76       7.91       4
read      3137.78    262144     65536      0.001204   1.30       1.14       1.31       4
remove    -          -          -          -          -          -          0.058712   4
Max Write: 531.41 MiB/sec (557.23 MB/sec)
Max Read:  19417.68 MiB/sec (20360.91 MB/sec)

Summary of all tests:
Operation   Max(MiB)   Min(MiB)  Mean(MiB)     StdDev   Max(OPs)   Min(OPs)  Mean(OPs)     StdDev    Mean(s) Stonewall(s) Stonewall(MiB) Test# #Tasks tPN reps fPP reord reordoff reordrand seed segcnt   blksiz    xsize aggs(MiB)   API RefNum
write         531.41     501.92     516.19       9.40       8.30       7.84       8.07       0.15    7.93762         NA            NA     0     16  16    5   1     1        1         0 0      1 268435456 67108864    4096.0 POSIX      0
read        19417.68     991.89    5194.59    7154.32     303.40      15.50      81.17     111.79    2.49070         NA            NA     0     16  16    5   1     1        1         0 0      1 268435456 67108864    4096.0 POSIX      0
Finished            : Thu Jun 23 00:04:35 2022
```

{{% notice info %}}
IOR is considered the standard tool in HPC to evaluate parallel file system performances, which makes it easy to compare results across systems. See also the [IO500 Benchmark](https://www.vi4io.org/std/io500/start). However, feel free to try other IO performance testing tools, such as [FIO](https://fio.readthedocs.io/en/latest/index.html) or [DD](https://www.unixtutorial.org/test-disk-speed-with-dd).
{{% /notice %}}
