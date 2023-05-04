+++
title = "m. Visualize Results"
date = 2023-04-10T10:46:30-04:00
weight = 130
tags = ["tutorial", "create", "ParallelCluster"]
+++

In this section, the results of the job just run will be visualised using [NCL](https://www.ncl.ucar.edu/). 

1. If not still connected, connect to the Head node via **DCV**, following instructions from part **[h. Connect to the Cluster](/03-hpc-aws-parallelcluster-workshop/08-connect-cluster.html#dcv-connect)**

2. Install NCL using:

```bash
sudo yum install -y ncl
```

3. Some of the default arguments for NCL need to be filled. Now that it has been installed, this can be done by sourcing the `.bashrc` file:

```bash
source ~/.bashrc
```

We will also set our default NCL X11 window size to be 1000x1000.

```bash
cat << EOF > $HOME/.hluresfile
*windowWorkstationClass*wkWidth  : 1000
*windowWorkstationClass*wkHeight : 1000
EOF
```

4. In a terminal navigate to the WRF run directory.

```bash
cd /shared/conus_12km
```

5. The provided `ncl_scripts/surface.ncl` script will generate two plots of surface fields at valid
   time 2019-11-27 00:00. Use the space bar to advance to the next plot.

```bash
ncl ncl_scripts/surface.ncl
```

![Surface temperature](/images/isc23/plt_Surface1.000001.png)

Use the space bar to advance to the next plot.

![Surface dew point](/images/isc23/plt_Surface1.000002.png)


6. Generate a vertical profile of relative humidity (%) and temperature (K).

```bash
ncl ncl_scripts/vert_crossSection.ncl
```

![Surface temperature](/images/isc23/plt_CrossSection_1.png)

Again, use the space bar to advance beyond the current plot.