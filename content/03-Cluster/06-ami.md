---
title: "e. Create a Machine Image"
date: 2020-05-12T13:27:03Z
weight : 40
tags : ["tutorial", "EFA", "ec2", "NCCL", "MPI", "Benchmark", "compile"]
---

Pcluster provides default [AMI](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html), but we can use custom AMI to make experience better for our use case. Lets look at 2 ways we can build custom AMI.

# DLAMI
[DLAMI](https://docs.aws.amazon.com/dlami/latest/devguide/what-is-dlami.html) contains GPU dependencies and ML frameworks (for example pytorch) which are seamlesly integrated with other AWS services like EFA.
Lets create `ami.yml` (see [DLAMI release notes](https://docs.aws.amazon.com/dlami/latest/devguide/appendix-ami-release-notes.html) to get AMI ARN (`ParentImage` in config bellow)):
```
Build:
  SecurityGroupIds: [<insert you SG - in requires outbound traffic>]
  SubnetId: subnet-123
  InstanceType: g5.2xlarge # you can choose different instance
  ParentImage: ami-123
```

Now run [pcluster command](https://docs.aws.amazon.com/parallelcluster/latest/ug/pcluster.build-image-v3.html) that will add all pcluster dependencies to your DLAMI of choice:
```
pcluster build-image -c ami.yml -i NEW_AMI_ID -r REGION
```

# Fully custom AMI
We created Packer configuration for AMI that allows you to customize different aspects of deep learning toolchain(for example use specific CUDA version).

#### 1 - Assets Required to Build the Image

First let's fetch the assets required to build the image:

```bash
wget https://ml.hpcworkshops.com/scripts/packer/packer.tar.gz
tar -xzf packer.tar.gz
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
