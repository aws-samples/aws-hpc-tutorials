---
title: "f. Install NCL"
weight: 27
tags: ["tutorial", "pcluster-manager", "ParallelCluster", "NCL"]
---

1. Next we'll download and install the [NCAR Command Language (NCL)](https://www.ncl.ucar.edu/). We will use NCL to visualize the output in the next few sections.


```bash
cd /shared
mkdir /shared/ncl
curl -OL https://www.earthsystemgrid.org/dataset/ncl.662.dap/file/ncl_ncarg-6.6.2-CentOS7.6_64bit_gnu485.tar.gz
tar xf ncl_ncarg-6.6.2-CentOS7.6_64bit_gnu485.tar.gz
rm ncl_ncarg-6.6.2-CentOS7.6_64bit_gnu485.tar.gz
```

This will take less than a minute to complete.

2. Next we need to NCARG_ROOT environment variable to the root directory of where the NCL software is installed and the `bin` directory to our `PATH`.

```bash
cat << EOF >> $HOME/.bashrc
export NCARG_ROOT=/shared/ncl
export PATH=$PATH:/shared/ncl
EOF
export NCARG_ROOT=/shared/ncl
export PATH=$PATH:/shared/ncl
```

3. We will also set our default NCL X11 window size to be 1000x1000.

```bash
cat << EOF > $HOME/.hluresfile
*windowWorkstationClass*wkWidth  : 1000
*windowWorkstationClass*wkHeight : 1000
EOF
```

