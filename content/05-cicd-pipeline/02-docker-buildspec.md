+++
title = "a. Define container files and build specification"
date = 2021-09-30T10:46:30-04:00
weight = 30
tags = ["tutorial", "DeveloperTools", "CodeCommit"]
+++

{{% notice info %}}This lab requires an AWS Cloud9 IDE. If you do not have an AWS Cloud9 IDE set up, complete the **[Prepartion](/02-aws-getting-started.html)** section of the workshop.
{{% /notice %}}

In this section, you will create a Docker container for the application and a buildspec file.


1. Open the [AWS Cloud9 console](https://console.aws.amazon.com/cloud9).
	
2. Choose **open IDE** for the Cloud9 instance set up previously. It may take a few moments for the IDE to open. AWS Cloud9 stops and restarts the instance so that you do not pay compute charges when no longer using the Cloud9 IDE.

3. Create a new directory called **MyDemoRepo** and enter it:

```
mkdir MyDemoRepo
cd MyDemoRepo
pwd # should be MyDemoRepo
```

4. Create our Spack build definition. You will be using [Spack](https://spack.io) to build our GROMACS application inside of our container. This definition sets what software is to be built, build options, and where to install the software. You will leave most of the build values as defaults, and will select the **x86_64_v3** architecture, which will build an optimized binary with **AVX2** extensions.  This architecture is also available in the [Spack rolling binary cache](https://aws.amazon.com/blogs/hpc/introducing-the-spack-rolling-binary-cache/) which will significantly speed up our build time. 

```bash
cat > ~/environment/MyDemoRepo/spack.yaml <<EOF
spack:
  specs:
  - gromacs
  - osu-micro-benchmarks
  packages:
    all:
      target: [ x86_64_v3 ]
  concretizer:
    unify: true
  config:
    install_tree: /opt/software
  view: /opt/view
EOF
```

5. Create a Dockerfile definition for the container. We will augment this container definition in a later step to add additional functionality that we will need. This container will include a complete [OpenMPI](https://openmpi.org) implementation, as well as an MPI-enabled version of the [GROMACS](https://gromacs.org) molecular dynamics application.  We're going to use the Spack-enabled [Amazon Linux container](https://gallery.ecr.aws/amazonlinux/amazonlinux) provided by the Spack project to build this container.

```bash
cat > ~/environment/MyDemoRepo/Dockerfile << EOF
FROM spack/amazon-linux:v0.18.0 as build
# Add our spack.yaml file that defines our build and environment
ADD spack.yaml /opt/spack-environment/spack.yaml
# Set up spack env & binary cache, then build the software
RUN spack env activate -d /opt/spack-environment \
&&  spack mirror add binary_mirror https://binaries.spack.io/releases/v0.18 \
&&  spack buildcache keys --install --trust \
&&  spack install --reuse --use-cache --fail-fast \
&&  spack gc -y \
&&  spack find -v
# Create a script to activate the spack environment on load
RUN spack env activate --sh -v -d /opt/spack-environment > /etc/profile.d/z10_spack_environment.sh 
ENTRYPOINT [ "/bin/bash", "-l" ]
EOF
```
Before you move on to building an automated CICD pipeline, you will build and run the container and push it to an [Elastic Container Registry](https://aws.amazon.com/ecr/) (ECR) container repository.

6. In the new terminal tab, create an ECR repository.

You will be using the Elastic Container repository (ECR) to store and distribute your container images once they are built.  Create the repository now.

```bash
aws ecr create-repository --repository-name sc22-container
```

You will use the **repositoryUri** later to reference this repositry. Fetch and display the URI with.


```bash
export IMAGE_URI=$(aws ecr describe-repositories --repository-name sc22-container --query "repositories[0].repositoryUri" --output text)                                                                                                                                                
echo $IMAGE_URI
```

In the next steps, you will use automated CICD pipeline tools to build the container image and update ECR. In addition to the automation, the CICD pipeline provides a sandbox environment with the ability to limit access to AWS resources using [AWS IAM](https://aws.amazon.com/iam/) while having elevated privileges. 
