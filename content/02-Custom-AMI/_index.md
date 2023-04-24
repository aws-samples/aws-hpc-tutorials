---
title: "Create a Deep Learning AMI"
weight: 20
pre: "<b>Part I ⁃ </b>"
tags: ["HPC", "Overview"]
---

![DL AMI Logo](/images/01-getting-started/dlami.jpeg)

This section documents how to build a ParallelCluster AMI based on the [Deep Learning AMI](https://docs.aws.amazon.com/dlami/latest/devguide/appendix-ami-release-notes.html). This means we'll take an ami that's pre-built for popular frameworks like [Tensorflow](https://docs.aws.amazon.com/dlami/latest/devguide/tutorial-tensorflow.html), [PyTorch](https://docs.aws.amazon.com/dlami/latest/devguide/tutorial-pytorch.html) or [MxNet](https://docs.aws.amazon.com/dlami/latest/devguide/tutorial-mxnet.html) and build on the parallelcluster components like Slurm, Lustre drivers ect.

#### 1 - Software Stack Installed

For example, in the [multi-framework Amazon Linux 2 AMI](https://aws.amazon.com/releasenotes/aws-deep-learning-ami-amazon-linux-2/), we get the following software stack:

- Supported EC2 Instances: G3, P3, P3dn, P4d, P4de, G5, G4dn, Inf1
- Operating System: `Amazon Linux 2`
- Compute Architecture: `x86`
- Conda environments framework and python versions:
- python3: `Python 3.10`
- tensorflow2_p310: `TensorFlow 2.12`, `Python 3.10`
- pytorch_p310: `PyTorch 2.0`, `Python 3.10`
- mxnet_p38: `Apache MXNet 1.9`, `Python 3.8`
- aws_neuron_pytorch_p37: `Python 3.7`
- aws_neuron_tensorflow2_p37: `Python 3.7`
- aws_neuron_mxnet_p37: `Python 3.7`
- NVIDIA Driver: `525.85.12`
- NVIDIA CUDA11 stack:
  - CUDA, NCCL and cuDDN installation path: `/usr/local/cuda-xx.x/`
  - EFA Installer: `1.19.0`
- AWS OFI NCCL: `1.5.0-aws`
- System location: `/usr/local/cuda-xx.x/efa`
- This is added to run NCCL tests located at `/usr/local/cuda-11.8/efa/test-cuda-xx.x/`

Also, PyTorch package comes with dynamically linked AWS OFI NCCL plugin as a conda package `aws-ofi-nccl-dlc` package as well and PyTorch will use that package instead of system AWS OFI NCCL.

- NCCL Tests Location: `/usr/local/cuda-xx.x/efa/test-cuda-xx.x/`
- EBS volume type: gp3