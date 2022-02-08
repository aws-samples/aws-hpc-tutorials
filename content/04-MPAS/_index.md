---
title: "Model for Prediction Across Scales (MPAS)"
weight: 40
pre: "<b>Part III ⁃ </b>"
tags: ["HPC", "Overview"]
---

![MPAS Logo](/images/mpas/logo.png)

In this section of the lab we'll setup the [Model for Prediction Across Scales (MPAS)](https://mpas-dev.github.io/). The MPAS model is a mesoscale numerical weather prediction system designed for both atmospheric research and operational forecasting applications. It is developed and maintained by by [National Center for Atmospheric Research (NCAR)](https://ncar.ucar.edu/what-we-offer/models/weather-research-and-forecasting-model-MPAS).

It's easy to install with the package manager Spack. Please complete the steps in [Preparation](/01-aws-getting-started.html) and
[Part 1: Create an HPC Cluster](02-cluster.html) before proceeding with MPAS.

To do so we've broken it down into the following steps:

1. Install MPAS with Spack
2. Download supercell test case
3. Run the test case
