---
title: "Create a Nvidia AMI"
weight: 20
pre: "<b>Part I ⁃ </b>"
tags: ["HPC", "Overview"]
---

This section documents how to build ParallelCluster AMIs with [Packer](https://www.packer.io/) from [HashiCorp](https://www.hashicorp.com/). You can run Packer on your own computer, an EC2 instance with suitable IAM rights or through an automated process with [AWS CodeBuild](https://docs.aws.amazon.com/codebuild/latest/userguide/welcome.html) associated to a code repository.

#### 1 - Software Stack Installed

The software stack installed on the AMI through packer consists of:

- [Nvidia Driver](https://www.nvidia.com/Download/index.aspx?lang=en-us) - 510.47.03
- [CUDA](https://developer.nvidia.com/cuda-downloads) - 11.6
- [CUDNN](https://developer.nvidia.com/cudnn) - v8
- [NVIDIA Container Toolkit](https://github.com/NVIDIA/nvidia-docker) - system latest
- Docker - system latest
- [NCCL](https://developer.nvidia.com/nccl) - v2.12.7-1
- [Pyxis](https://github.com/NVIDIA/pyxis) - v0.12.0"
- [Enroot](https://github.com/NVIDIA/enroot) - latest
- [AWS CLI V2](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) - latest for Nvidia Driver 510.47.03
- [Nvidia Fabric Manager](https://docs.nvidia.com/datacenter/tesla/pdf/fabric-manager-user-guide.pdf) - latest
- [EFA Driver](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/efa-start.html) - latest
- [EFA OFI NCCL plugin](https://github.com/aws/aws-ofi-nccl) - latest
- [NCCL Tests](https://github.com/NVIDIA/nccl-tests) - Latest
- [Intel MKL](https://www.intel.com/content/www/us/en/develop/documentation/get-started-with-mkl-for-dpcpp/top.html) - 2020.0-088
