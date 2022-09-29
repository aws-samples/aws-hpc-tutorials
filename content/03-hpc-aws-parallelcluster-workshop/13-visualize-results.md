+++
title = "n. Visualize Results"
date = 2022-04-10T10:46:30-04:00
weight = 120
tags = ["tutorial", "create", "ParallelCluster"]
+++

In this next section, we're going to visualize the results of the job we just ran using [NCL](https://www.ncl.ucar.edu/). NCL will be pre-installed on your Cluster.

1. Connect to the Head node via DCV, following instructions from part **[h. Connect to the Cluster](/03-hpc-aws-parallelcluster-workshop/09-connect-cluster.html#dcv-connect)**

2. Open a terminal and install NCL.
```bash
sudo yum install -y -q ncl
```
3. Navigate to the WRF run directory.

```bash
cd /shared/conus_12km
```

4. The provided `ncl_scripts/surface.ncl` script will generate two plots of surface fields at valid
   time 2019-11-27 00:00. Use the space bar to advance to the next plot.

```bash
ncl ncl_scripts/surface.ncl
```

![Surface temperature](/images/sc22/plt_Surface1.000001.png)

Use the space bar to advance to the next plot.

![Surface dew point](/images/sc22/plt_Surface1.000002.png)

5. Generate a vertical profile of relative humidity (%) and temperature (K).

```bash
ncl ncl_scripts/vert_crossSection.ncl
```

![Surface temperature](/images/sc22/plt_CrossSection_1.png)
