---
title: "d. Visualize Results"
weight: 44
tags: ["tutorial", "pcluster-manager", "MPAS", "NCL", "dcv"]
---

In this next section, we're going to visualize the results of the job we just ran using [NCL](https://www.ncl.ucar.edu/). Please complete the steps in [Preparation](/01-aws-getting-started.html) and [Part 1: Create an HPC Cluster](/02-cluster.html) before proceeding, as the [f. Install NCL](/02-cluster/07-install-ncl.html) step installs NCL.

1. Connect to the Head node via DCV, following instructions from part **[b. Connect to the Cluster](/02-cluster/02-connect-cluster.html#dcv-connect)**

2. The `supercell.ncl` script by default will produce a PDF file of the plots. We are going to change this to X11 with the following command.

```bash
sed -i 's/pdf/x11/' supercell.ncl
```

3. Visualize the supercell following variables at various levels and forecast times.
   - Perturbation potential temperature (perturbation theta)
   - Upward component of wind (w)
   - Rain water mixing ratio (qr)

```bash
ncl supercell.ncl
```

![MPAS perturbation theta](/images/mpas/supercell.png)
