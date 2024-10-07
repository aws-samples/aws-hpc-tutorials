+++
title = "g. Install IOR Benchmark Tool"
date = 2019-09-18T10:46:30-04:00
weight = 70
tags = ["tutorial", "install", "FSx", "Performances"]
+++

You can conduct performance tests on your Lustre partition to evaluate the [throughput](https://docs.aws.amazon.com/fsx/latest/LustreGuide/performance.html#fsx-aggregate-perf) it provides. To do so, you must first install [IOR](https://github.com/hpc/ior), an IO parallel benchmark tool used to test the performance of a parallel file system.


Use the following command to install IOR. For this installation, use the *io500-sc19* branch of the repository on the cluster head node.

```bash
# get IOR
mkdir -p /shared/ior
git clone https://github.com/hpc/ior.git
cd ior
git checkout io500-sc19

# load intelmpi
module load intelmpi

# install
./bootstrap
./configure --with-mpiio --prefix=/shared/ior
make -j 10
sudo make install

# set the environment
export PATH=$PATH:/shared/ior/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/shared/ior/lib
echo 'export PATH=$PATH:/shared/ior/bin' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/shared/ior/lib' >> ~/.bashrc
```

Now, you are ready to do some performance testing.
