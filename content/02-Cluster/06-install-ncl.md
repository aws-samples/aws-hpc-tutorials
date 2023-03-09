---
title: "f. Install NCL"
weight: 26
tags: ["tutorial", "pcluster-manager", "ParallelCluster", "NCL"]
---

1. Next we'll install the [NCAR Command Language (NCL)](https://www.ncl.ucar.edu/). We will use NCL to visualize the output in the next few sections.


```bash
spack install ncl^hdf5@1.8.22
```


| **Spack Flag** | **Description** |
| ----------- | ----------- |
| `ncl` | Install the NCL package. |
| `^hdf5@1.8.22` | Pin the HDF5 dependency at version 1.8.22. |

This will take about 4 minutes to complete.

2. To test and make sure `ncl` is setup correctly.

```bash
spack load ncl
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

3. We will also set our default NCL X11 window size to be 1000x1000.

```bash
cat << EOF > $HOME/.hluresfile
*windowWorkstationClass*wkWidth  : 1000
*windowWorkstationClass*wkHeight : 1000
EOF
```

