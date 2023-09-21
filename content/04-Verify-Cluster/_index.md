---
title: "EFA NCCL Tests"
weight: 40
pre: "<b>Part III ⁃ </b>"
tags: ["HPC", "Overview"]
---

In this section we'll run the [NCCL Tests](https://github.com/NVIDIA/nccl-tests), specifically the *All Reduce* tests which are a suite of tests intended to validate the networking performance of the cluster. 

We'll check to see that EFA is enabled and the bandwidth matches the spec:

| Instance Type  | Network Bandwidth | GPU Peer to Peer  |
|----------------|-------------------|:-----------------:|
|  p4d.24xlarge  |  200 Gbps EFAv1   | 600 GB/s NVSwitch | 
|  p4de.24xlarge |  400 Gbps EFAv1   | 600 GB/s NVSwitch | 
|  p5.48xlarge   |  3200 Gbps EFAv2  | 900 GB/s NVSwitch |   