+++
title = "m. Visualize Results"
date = 2023-04-10T10:46:30-04:00
weight = 130
tags = ["tutorial", "create", "ParallelCluster"]
+++

In this next section, we're going to visualize the results of the job we just ran using [NCL](https://www.ncl.ucar.edu/). Please complete the steps in [Preparation](/01-aws-getting-started.html) and [Part 1: Create an HPC Cluster](/02-cluster.html) before proceeding, as the [f. Install NCL](/02-cluster/07-install-ncl.html) step installs NCL.

1. Connect to the Head node via **DCV**, following instructions from part **[b. Connect to the Cluster](/02-cluster/02-connect-cluster.html#dcv-connect)**

2. In a terminal navigate to the WRF run directory.

```bash
cd /shared/conus_12km
```

3. The provided `ncl_scripts/surface.ncl` script will generate two plots of surface fields at valid
   time 2019-11-27 00:00. Use the space bar to advance to the next plot.

```bash
spack load ncl
ncl ncl_scripts/surface.ncl
```

![Surface temperature](/images/isc23/plt_Surface1.000001.png)

Use the space bar to advance to the next plot.

![Surface dew point](/images/isc23/plt_Surface1.000002.png)


4. Generate a vertical profile of relative humidity (%) and temperature (K).

```bash
ncl ncl_scripts/vert_crossSection.ncl
```

![Surface temperature](/images/isc23/plt_CrossSection_1.png)