---
title: "d. Visualize Results"
weight: 54
tags: ["tutorial", "pcluster-manager", "UFS", "NCL", "dcv"]
---

In this next section, we're going to visualize the results of the job we just ran using [NCL](https://www.ncl.ucar.edu/). Please complete the steps in [Preparation](/01-aws-getting-started.html) and [Part 1: Create an HPC Cluster](/02-cluster.html) before proceeding, as the [f. Install NCL](/02-cluster/07-install-ncl.html) step installs NCL.

1. Connect to the Head node via DCV, following instructions from part **[b. Connect to the Cluster](/02-cluster/02-connect-cluster.html#dcv-connect)**

2. Download an NCL script for plotting the results of the forecast.

```bash
curl -OL https://raw.githubusercontent.com/wiki/ufs-community/ufs-mrweather-app/files/plot_ufs_sfcf.ncl
```

3. Change the output format of the plots from PNG to X11 and the input file
   from `sfcf` to `phyf` with the following `sed` command.

```bash
sed -i 's/png/x11/; s/sfcf/phyf/' plot_ufs_sfcf.ncl
```

4. Create the plots of the forecast at 24 hours.

```bash
spack load ncl
ncl plot_ufs_sfcf.ncl 's="024"'
```

![2 metre temperate](/images/ufs/plot_ufs_phyf_tmp2m.png)
![Total precipitation](/images/ufs/plot_ufs_phyf_tprcp.png)
