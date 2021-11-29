+++
title = "i. Optional - Run IOR"
date = 2019-09-18T10:46:30-04:00
weight = 90
tags = ["tutorial", "IOR", "ParallelCluster"]
+++

{{% notice note %}}
This exercise is optional, feel free to skip it if you prefer to go directly to the next part of the lab.
{{% /notice %}}

You will now run an performance testing application called [IOR](https://github.com/hpc/ior). It is a tool commonly used to evaluate the performance of Parallel Shared Filesystems in HPC. In this exercise you run IOR with the `/shared` directory which is represented by an EBS shared over NFS between all nodes of your cluster. This EBS volume, of type [GP2](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-volume-types.html#EBSVolumeTypes_gp2), is 35GB in size and can provide up to 28MB/s of throughput. This is just for testing in the context of this lab. You would use larger volumes and Amazon FSx for Lustre in a production grade cluster. Feel free to create a cluster with FSx for Lustre if you want to [test a configuration](https://docs.aws.amazon.com/parallelcluster/latest/ug/SharedStorage-v3.html#SharedStorage-v3-FsxLustreSettings) more appropriate for [IO throughput](https://docs.aws.amazon.com/fsx/latest/LustreGuide/performance.html#fsx-aggregate-perf).


#### Install IOR

Use the following command to install IOR. For this installation, use the *io500-sc19* branch of the repository on the cluster head node.

```bash
# get IOR
mkdir -p /home/ec2-user/ior
git clone https://github.com/hpc/ior.git
cd ior
git checkout io500-sc19

# load intelmpi
module load intelmpi

# install
./bootstrap
./configure --with-mpiio --prefix=/home/ec2-user/ior
make -j 10
sudo make install

# set the environment
export PATH=$PATH:/home/ec2-user/ior/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/ec2-user/ior/lib
echo 'export PATH=$PATH:/home/ec2-user/ior/bin' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/ec2-user/ior/lib' >> ~/.bashrc
```

To measure throughput, you tune several IOR parameters to favor POSIX as an IO access method and conduct direct access to the file system. This approach helps you bypass almost all caching and evaluate the raw performances of Amazon FSx for Lustre. Further, you generate one file per process to saturate the file system.

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
#SBATCH --output=%x_%j.out

mpirun /home/ec2-user/ior/bin/ior -w -r -o=/home/ec2-user/test_dir -b=256m -a=POSIX -i=5 -F -z -t=64m -C
EOF
```

Then, submit the script with **sbatch** as follows.

```bash
# go to home again
cd ~
sbatch ior_submission.sbatch
```

The IOR output is written to an **.out** file. If you want, you can use **tail -f** to view the file as it is written. However, remember that since you have 0 compute nodes present on your cluster, it may take up to 1 minute  for instances to be created then register with the cluster. You can check the status of the instances on the [EC2 Dashboard](https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#Instances:sort=instanceState) in the AWS Management Console. After the instances are created and registered, the IOR job will run.


How much did throughput you get when testing?


{{% notice info %}}
IOR is considered the standard tool in HPC to evaluate parallel file system performances, which makes it easy to compare results across systems. See also the [IO500 Benchmark](https://www.vi4io.org/std/io500/start). However, feel free to try other IO performance testing tools, such as [FIO](https://fio.readthedocs.io/en/latest/index.html) or [DD](https://www.unixtutorial.org/test-disk-speed-with-dd).
{{% /notice %}}

