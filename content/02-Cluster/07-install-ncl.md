---
title: "f. Install NCL"
weight: 27
tags: ["tutorial", "pcluster-manager", "ParallelCluster", "NCL"]
---

1. Next we'll download and install a pre-compiled version of the [NCAR Command Language (NCL)](https://www.ncl.ucar.edu/) from the [Earth System Grid](https://www.earthsystemgrid.org/dataset/ncl.662.dap.html). We will use NCL to visualize the output in the next few sections.


```bash
mkdir /shared/ncl && cd $_
curl -OL https://www.earthsystemgrid.org/dataset/ncl.662.dap/file/ncl_ncarg-6.6.2-CentOS7.6_64bit_gnu485.tar.gz
tar xf ncl_ncarg-6.6.2-CentOS7.6_64bit_gnu485.tar.gz
rm ncl_ncarg-6.6.2-CentOS7.6_64bit_gnu485.tar.gz
```

This will take less than a minute to complete.

2. We also need to install the libraries NCL depends on

```bash
sudo yum install -y compat-gcc-48-libgfortran
```

3. Next we need to NCARG_ROOT environment variable to the root directory of where the NCL software is installed and the `bin` directory to our `PATH `.

```bash
cat << EOF >> $HOME/.bashrc
export NCARG_ROOT=/shared/ncl
export PATH=\$PATH:/shared/ncl/bin
EOF
export NCARG_ROOT=/shared/ncl
export PATH=$PATH:/shared/ncl/bin
```

4. To test and make sure ncl is setup correctly on the path run 

```bash
ncl -h
```

You should see the following output:


```bash
Usage: ncl -fhnopxsPQV <args> <file.ncl>
         -f: use new file structure and NetCDF4 features when possible
         -h: print this message and exit
         -n: don't enumerate values in print()
         -o: retain former behavior for certain backwards-incompatible changes
         -p: don't page output from the system() command
         -x: echo NCL commands
         -s: disable pre-loading of default script files
         -P: enable NCL profiler
         -Q: turn off echo of NCL version and copyright info
         -V: print NCL version and exit
```

5. We will also set our default NCL X11 window size to be 1000x1000.

```bash
cat << EOF > $HOME/.hluresfile
*windowWorkstationClass*wkWidth  : 1000
*windowWorkstationClass*wkHeight : 1000
EOF
```

