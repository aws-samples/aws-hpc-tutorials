#!/bin/bash

# get HPCG
cd $HOME

mkdir hpcg
cd hpcg
wget https://github.com/hpcg-benchmark/hpcg/archive/master.zip
unzip master.zip
hpcg-master/configure Linux_MPI
module load openmpi/4.0.3
make -j 2

# get IOR
cd $HOME
mkdir -p /shared/ior
git clone https://github.com/hpc/ior.git
cd ior
git checkout io500-sc19

# load intelmpi
module load intelmpi

# install
./bootstrap
./configure --with-mpiio --prefix=/shared/ior
make -j 2
sudo make install

# set the environment
export PATH=$PATH:/shared/ior/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/shared/ior/lib
echo 'export PATH=$PATH:/shared/ior/bin' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/shared/ior/lib' >> ~/.bashrc