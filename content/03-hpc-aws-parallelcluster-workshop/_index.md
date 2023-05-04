---
title: "Create an HPC Cluster"
date: 2023-04-11T09:05:54Z
weight: 30
pre: "<b>Lab I ⁃ </b>"
tags: ["HPC", "Overview"]
---
In this lab, you are introduced to [AWS ParallelCluster](https://aws.amazon.com/hpc/parallelcluster/) and will run a Weather forecast model (WRF) on the HPC Cluster on AWS. This workshop includes the following steps:

- Install and configure ParallelCluster on your AWS Cloud9 IDE.
- Create your HPC cluster in AWS.
- Connect to ParallelCluster UI.
- Connect to your new cluster via the ParallelCluster UI console.
- Download CONUS 12km model.
- Submit a WRF forecast and check what is happening in the background.
- Visualize the results of the WRF job.

#### About Weather Research and Forecasting (WRF)
The [Weather Research and Forecasting (WRF) Model](https://ncar.ucar.edu/what-we-offer/models/weather-research-and-forecasting-model-wrf) is a next-generation mesoscale numerical weather prediction system designed for both atmospheric research and operational forecasting applications. It is developed and maintained by the [National Center for Atmospheric Research (NCAR)](https://ncar.ucar.edu/what-we-offer/models/weather-research-and-forecasting-model-wrf).

It features a dynamical core, a data assimilation system, and a software architecture supporting parallel computation and system extensibility. The model serves a wide range of meteorological applications across scales from tens of meters to thousands of kilometers.

The effort to develop WRF began in the latter 1990's and was a collaborative partnership of the National Center for Atmospheric Research (NCAR), the National Oceanic and Atmospheric Administration (represented by the National Centers for Environmental Prediction (NCEP) and the Earth System Research Laboratory), the U.S. Air Force, the Naval Research Laboratory, the University of Oklahoma, and the Federal Aviation Administration (FAA).

WRF is a tightly coupled application that uses MPI and OpenMP.