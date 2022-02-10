---
title: "Unified Forecast System (UFS)"
weight: 50
pre: "<b>Part IV ⁃ </b>"
tags: ["HPC", "Overview"]
---

![UFS Logo](/images/ufs/logo.png)

In this section of the lab we'll setup the [Unified Forecast System (UFS)](https://ufscommunity.org/). The UFS is a community-based, coupled, comprehensive Earth modeling system. The UFS numerical applications span local to global domains and predictive time scales from sub-hourly analyses to seasonal predictions. It is designed to support the [Weather Enterprise](https://www.weather.gov/about/weather-enterprise) and to be the source system for [NOAA](https://www.noaa.gov/)‘s operational numerical weather prediction applications.

It's easy to install with the package manager Spack. Please complete the steps in [Preparation](/01-aws-getting-started.html) and
[Part 1: Create an HPC Cluster](02-cluster.html) before proceeding with UFS.

To do so we've broken it down into the following steps:

1. Install UFS with Spack
2. Download the simple test case
3. Run the test case
