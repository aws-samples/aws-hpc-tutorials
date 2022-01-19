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
conda install -c conda-forge wrf-python netCDF4 matplotlib Cython pyproj imageio termcolor
```

4. Install [GOES](https://spack.readthedocs.io/en/latest/package_list.html#geos) library. GEOS is a C/C++ library for spatial computational geometry that's used as a dependency of wrf-python.

```bash
spack install geos
```

5. Install [matplotlib basemap](https://matplotlib.org/basemap/index.html) tool:

```bash
curl -O https://github.com/matplotlib/basemap/archive/refs/tags/v1.2.2rel.tar.gz
tar -xzf v1.2.2rel.tar.gz
cd basemap-1.2.2rel/
GEOS_DIR=$(spack location -i geos)
python setup.py install
```

6. Next create a python script in `/shared/conus_12km` directory to visualize the results, this script [Horizontal Interpolation to a Pressure Level](https://wrf-python.readthedocs.io/en/latest/plot.html#horizontal-interpolation-to-a-pressure-level) is from the wrf-python examples. We've adapted it to create an animation instead of static images.

```python
cd /shared/conus_12km
cat <<- EOF > wrf-visualize.py
from netCDF4 import Dataset
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.cm import get_cmap
import sys
import imageio
from glob import iglob
from termcolor import colored
import os

from wrf import getvar, interplevel, to_np, get_basemap, latlon_coords

# Open the NetCDF file
images = []
for index, forecast in enumerate(iglob(sys.argv[1])):
    print(f"Processing {colored(forecast, 'green')} ...")
    ncfile = Dataset(forecast)

    # Extract the pressure, geopotential height, and wind variables
    p = getvar(ncfile, "pressure")
    z = getvar(ncfile, "z", units="dm")
    ua = getvar(ncfile, "ua", units="kt")
    va = getvar(ncfile, "va", units="kt")
    wspd = getvar(ncfile, "wspd_wdir", units="kts")[0,:]

    # Interpolate geopotential height, u, and v winds to 500 hPa
    ht_500 = interplevel(z, p, 500)
    u_500 = interplevel(ua, p, 500)
    v_500 = interplevel(va, p, 500)
    wspd_500 = interplevel(wspd, p, 500)

    # Get the lat/lon coordinates
    lats, lons = latlon_coords(ht_500)

    # Get the basemap object
    bm = get_basemap(ht_500)

    # Create the figure
    fig = plt.figure(figsize=(12,9))
    ax = plt.axes()

    # Convert the lat/lon coordinates to x/y coordinates in the projection space
    x, y = bm(to_np(lons), to_np(lats))

    # Add the 500 hPa geopotential height contours
    levels = np.arange(520., 580., 6.)
    contours = bm.contour(x, y, to_np(ht_500), levels=levels, colors="black")
    plt.clabel(contours, inline=1, fontsize=10, fmt="%i")

    # Add the wind speed contours
    levels = [25, 30, 35, 40, 50, 60, 70, 80, 90, 100, 110, 120]
    wspd_contours = bm.contourf(x, y, to_np(wspd_500), levels=levels,
                            cmap=get_cmap("rainbow"))
    plt.colorbar(wspd_contours, ax=ax, orientation="horizontal", pad=.05)

    # Add the geographic boundaries
    bm.drawcoastlines(linewidth=0.25)
    bm.drawstates(linewidth=0.25)
    bm.drawcountries(linewidth=0.25)

    # Add the 500 hPa wind barbs, only plotting every 125th data point.
    bm.barbs(x[::125,::125], y[::125,::125], to_np(u_500[::125, ::125]),
             to_np(v_500[::125, ::125]), length=6)

    plt.title("500 MB Height (dm), Wind Speed (kt), Barbs (kt)")

    plt.savefig(f"plt-wrf-{index}.png")
    images += [f"plt-wrf-{index}.png"]
    print(f"\tWriting plt-wrf-{index}.png")

gif = []
for image in images:
    gif.append(imageio.imread(image))
imageio.mimsave('wrf.gif', gif)

print(f"Saved output to {colored(os.path.abspath('wrf.gif'), 'blue')}")
EOF
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