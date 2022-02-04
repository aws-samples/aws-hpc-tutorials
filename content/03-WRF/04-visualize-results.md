---
title: "d. Visualize Results"
weight: 34
tags: ["tutorial", "pcluster-manager", "python-wrf", "dcv"]
---

In this next section, we're going to visualize the results of the job we just ran using a tool called [wrf-python](https://wrf-python.readthedocs.io/en/latest/installation.html) a popular tool to plot netCDF files output from WRF. When we're done we'll see an animation that looks like the following:

![WRF Visualization](/images/wrf/wrf.gif)

1. Connect to the Head node via DCV, following instructions from part **[b. Connect to the Cluster](02-cluster/02-connect-cluster.html#dcv-connect)**

2. Next we need to install [Miniconda](https://docs.conda.io/projects/conda/en/latest/user-guide/install/linux.html):

```bash
curl -O https://repo.anaconda.com/miniconda/Miniconda3-py37_4.10.3-Linux-x86_64.sh
bash Miniconda3-py37_4.10.3-Linux-x86_64.sh
```

3. Next we'll use conda to install wrf-python and dependencies needed:

```bash
source ~/.bashrc
conda install -c conda-forge wrf-python netCDF4 matplotlib Cython pyproj imageio termcolor
```

4. Install [GOES](https://spack.readthedocs.io/en/latest/package_list.html#geos) library. GEOS is a C/C++ library for spatial computational geometry that's used as a dependency of wrf-python.

```bash
spack install geos
```

5. Install [matplotlib basemap](https://matplotlib.org/basemap/index.html) tool:

```bash
curl -OL https://github.com/matplotlib/basemap/archive/refs/tags/v1.2.2rel.tar.gz
tar -xzf v1.2.2rel.tar.gz
cd basemap-1.2.2rel/
export GEOS_DIR=$(spack location -i geos)
python setup.py install
```

6. Next create a python script in `/shared/conus_12km` directory to visualize the results, this script [Horizontal Interpolation to a Pressure Level](https://wrf-python.readthedocs.io/en/latest/plot.html#horizontal-interpolation-to-a-pressure-level) is from the wrf-python examples. We've adapted it to create an animation instead of static images. You can view the script [here](/scripts/wrf-visualize.py).

```python
cd /shared/conus_12km
curl -O https://weather.hpcworkshops.com/scripts/wrf-visualize.py
```

7. Next run the python file, pass in the regex pattern for the wrf output files as the first argument:

```bash
python3 wrf-visualize.py "wrfout_d01_*"
```

8. Now let's open up the GIF we created! First we're going to install Google Chrome:

```bash
sudo amazon-linux-extras install epel
sudo yum install -y chromium
```

Now making sure you're connected via **[b. Connect to the Cluster (DCV)](02-cluster/02-connect-cluster.html#dcv-connect)**, run:

```bash
chromium-browser /shared/conus_12km/wrf.gif
```

You'll see the animation playing in the Google Chrome window.

![WRF Chromium](/images/wrf/wrf-chromium.png)