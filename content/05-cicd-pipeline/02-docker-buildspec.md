+++
title = "a. Define container files and build specification"
date = 2021-09-30T10:46:30-04:00
weight = 30
tags = ["tutorial", "DeveloperTools", "CodeCommit"]
+++

{{% notice info %}}This lab requires an AWS Cloud9 IDE. If you do not have an AWS Cloud9 IDE set up, complete the **[Prepartion](/02-aws-getting-started.html)** section of the workshop.
{{% /notice %}}

In this section, you will create a Docker container for the application and a buildspec file.


1. In the AWS Management Console search bar, type and select **Cloud9**.
	
2. Choose **open IDE** for the Cloud9 instance set up previously. It may take a few moments for the IDE to open. AWS Cloud9 stops and restarts the instance so that you do not pay compute charges when no longer using the Cloud9 IDE.

3. Create a new directory called **MyDemoRepo** and enter it:

```
mkdir MyDemoRepo
cd MyDemoRepo
pwd # should be MyDemoRepo
```

4. Create our Spack build definition.  We will be using [Spack](https://spack.io) to build our GROMACS application inside of our container.  This defintion sets what software is to be built, build options, and where to install the software.  We leave most of the build values as defaults, and select the **x86_64_v4** architecture, which will enable building with **AVX512** optimizations.  This architecture is also available in the [Spack rolling binary cache](https://aws.amazon.com/blogs/hpc/introducing-the-spack-rolling-binary-cache/) which will significantly speed up our build time.

```bash
cat > spack.yaml <<EOF
spack:
  specs:
  - gromacs
  packages:
    all:
      target: [ x86_64_v4 ]
  concretizer:
    unify: true
  config:
    install_tree: /opt/software
  view: /opt/view
EOF
```

5. Create a Dockerfile definition for the container. We will augment this container definition in a later step to add additional functionality that we will need. This container will include a complete [OpenMPI](https://openmpi.org) implementation, as well as an MPI-enabled version of the [GROMACS](https://gromacs.org) molecular dynamics application.  We're going to use the Spack-enabled [Amazon Linux container](https://gallery.ecr.aws/amazonlinux/amazonlinux) provided by the Spack project to build this container.

```bash
cat > Dockerfile << EOF
FROM spack/amazon-linux:v0.18.0 as build
# Add our spack.yaml file that defines our build and environment
ADD spack.yaml /opt/spack-environment/spack.yaml
# Set up spack env & binary cache, then build the software
RUN spack env activate -d /opt/spack-environment \
&&  spack mirror add binary_mirror https://binaries.spack.io/releaes/v0.18 \
&&  spack buildcache keys --install --trust \
&&  spack install --reuse --use-cache --fail-fast \
&&  spack gc -y \
&&  spack find -v
# Create a script to activate the spack environment on load
RUN spack env activate --sh -v -d /opt/spack-environment > /etc/profile.d/z10_spack_environment.sh 
ENTRYPOINT [ "/bin/bash", "-l" ]
EOF
```

We could use standard **docker build** commands to build this description into a container image, but we will use automated CICD pipeline tools to do this work for us in the following steps.