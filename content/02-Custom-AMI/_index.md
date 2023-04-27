---
title: "Create a AMI"
weight: 20
pre: "<b>Part I ⁃ </b>"
tags: ["HPC", "Overview"]
---

You have two options for building a machine image. The first is the [Deep Learning AMI](https://aws.amazon.com/machine-learning/amis/). This is the easier option as there's [pre-built versions](https://docs.aws.amazon.com/dlami/latest/devguide/appendix-ami-release-notes.html) versions for popular frameworks like [Tensorflow](https://docs.aws.amazon.com/dlami/latest/devguide/tutorial-tensorflow.html), [PyTorch](https://docs.aws.amazon.com/dlami/latest/devguide/tutorial-pytorch.html) or [MxNet](https://docs.aws.amazon.com/dlami/latest/devguide/tutorial-mxnet.html).

The second is the [parallelcluster-efa-gpu-preflight](https://github.com/aws-samples/parallelcluster-efa-gpu-preflight-ami/tree/main) repository. This option allows you more control on the software stack, such as custom CUDA versions, container support via [Pyxis](https://github.com/NVIDIA/pyxis) and [Enroot](https://github.com/NVIDIA/enroot). 

Here's an example of the two different images. Pick one and proceed to either [**a. Deep Learning AMI**](02-custom-ami/01-custom-ami.html) or [**b. Custom AMI with Packer (Optional)**](02-custom-ami/02-packer.html).

#### 1 - Deep Learning AMI

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

#### 2 - Custom Packer AMI

The [parallelcluster-efa-gpu-preflight](https://github.com/aws-samples/parallelcluster-efa-gpu-preflight-ami/tree/main) repository includes the following software stack.

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