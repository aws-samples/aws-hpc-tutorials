+++
title = "l. Visualize Results"
date = 2022-04-10T10:46:30-04:00
weight = 120
tags = ["tutorial", "create", "ParallelCluster"]
+++

In this next section, we're going to visualize the results of the job we just ran using [NCL](https://www.ncl.ucar.edu/).

1. Install NCL.
```bash
sudo yum install -y ncl
```

2. Connect to the Head node via DCV, following instructions from part **[h. Connect to the Cluster](/03-hpc-aws-parallelcluster-workshop/09-connect-cluster.html#dcv-connect)**

3. Navigate to the WRF run directory.

```bash
cd /shared/conus_12km
```

4. Run `ncl` to generate two plots of surface fields.

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
