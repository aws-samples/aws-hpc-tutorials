---
title: "b. Custom AMI with Packer (Optional)"
weight: 21
tags: ["tutorial", "cloud9", "ParallelCluster"]
---

This section documents how to build ParallelCluster AMIs with [Packer](https://www.packer.io/) from [HashiCorp](https://www.hashicorp.com/). You can run Packer on your own computer, an EC2 instance with suitable IAM rights or through an automated process with [AWS CodeBuild](https://docs.aws.amazon.com/codebuild/latest/userguide/welcome.html) associated to a code repository.

#### 1 - Assets Required to Build the Image

First let's fetch the assets required to build the image:

```bash
git clone https://github.com/aws-samples/parallelcluster-efa-gpu-preflight-ami.git
cd parallelcluster-efa-gpu-preflight-ami/
```

This consists of:
* `nvidia-efa-ml-al2-enroot_pyxis.json`: is your main image file, it consists of several sections to define the resources (instance, base AMI, security groups...) you will use to build your image. The base AMI is a ParallelCluster Amazon Linux 2 base AMI. The provisioners section consists of inline scripts that will be executed serially to install the desired software stack onto your image.
* `variables.json`: contains some key variables. Packer will refer to them in the image script through user variables calls.
* `enroot.com`: in the enroot directory contains the [Enroot](https://github.com/NVIDIA/enroot) configuration that will be copied to your AMI.

#### 2 - Installing Packer

You can install Packer using [Brew](https://brew.sh/) on OSX or Linux as follows:

```bash
brew install packer
```

Alternatively, you can download the Packer binary through the [tool website](https://www.packer.io/). Ensure your `PATH` is set to use the binary or use its absolute path. Once Packer installed, proceed to the next stage.

#### 3 - Build Your Image

Once packer installed, from the assets directory run the command below:

```bash
packer build -color=true -var-file variables.json nvidia-efa-ml-al2-enroot_pyxis.json | tee build_AL2.log
```

Packer will start by creating the instances and associated resources (EC2 Key, Security Group...), run through the installation scripts, shutdown the instance and image it then terminate the instance.

The process is automated and the output will be displayed on your terminal. If Packer encounters an error during the installation, it will stop the process and terminate all the resources. You will have to go through its log to identify where the error occurred and correct it.

Once the image build, feel free to use it to create new clusters. The image will be retrieval from the Amazon EC2 Console under "Images -> AMIs"