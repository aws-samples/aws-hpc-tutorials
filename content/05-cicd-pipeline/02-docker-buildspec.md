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

4. Create our Spack build definition. You will be using [Spack](https://spack.io) to build our GROMACS application inside of our container. This definition sets what software is to be built, build options, and where to install the software. You will leave most of the build values as defaults, and will select the **x86_64_v4** architecture, which will enable building with **AVX512** optimizations.  This architecture is also available in the [Spack rolling binary cache](https://aws.amazon.com/blogs/hpc/introducing-the-spack-rolling-binary-cache/) which will significantly speed up our build time. 

```bash
cat > spack.yaml <<EOF
spack:
  specs:
  - gromacs
  - osu-micro-benchmarks
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

6. Build the Docker container.  We will use the **Dockerfile** definition we just created to build a minimum workable container with Gromacs and OpenMPI installed.

```bash
docker build . -f Dockerfile -t gromacs
```

This step will take 5-6 minutes to complete.  We will move on by creating a new terminal tab.  Click the green plus symbol in the tab list, and select **New Terminal**.

![AWS CodeBuild](/images/cicd/docker-1.png)

7. In the new terminal tab, create an ECR repository.

```bash
aws ecr create-repository --repository-name sc22-container
```

You will use the **repositoryUri** later to reference this repositry. Fetch and display the URI with.


```bash
export IMAGE_URI=$(aws ecr describe-repositories --repository-name sc22-container --query "repositories[0].repositoryUri" --output text)                                                                                                                                                
echo $IMAGE_URI
```

8. Authenticate docker to the ECR repository.

For Docker to interact with Amazon ECR, you will need to authenticate to the container registry of your AWS account.

The following commands will:
- Extract the base ECR URI from the container repository URI (needed for authentication).
- Get a single-use authentication password from ecr and pass it to **docker login** to authenticate docker.

```bash
export ECR_URI=$(echo $IMAGE_URI | awk -F/ '{print $1}')
aws ecr get-login-password | docker login --username AWS --password-stdin ${ECR_URI}
```

9. Test the container.

At this point your container build should be close to completion.  If the container build completed successfully, you should see:

```bash
...
Step 5/5 : ENTRYPOINT [ "/bin/bash", "-l" ]
 ---> Running in c0b85c3d0d70
Removing intermediate container c0b85c3d0d70
 ---> ba0af12d9fe9
Successfully built ba0af12d9fe9
Successfully tagged gromacs:latest
```

If it hasn't yet completed, now is a good time to open the [ECR Console](https://us-east-2.console.aws.amazon.com/ecr/repositories) and get familiar with the console features of ECR.

You will now test the container.  Run an instance of the container.

```bash
docker run -it --rm gromacs:latest
```

You will be presented with a different bash prompt.  You can inspect the installed OpenMPI and Gromacs.

```bash
bash-4.2# mpirun --version
mpirun (Open MPI) 4.1.3

Report bugs to http://www.open-mpi.org/community/help/
bash-4.2# gmx_mpi --version
                    :-) GROMACS - gmx_mpi, 2021.5-spack (-:
                    ...
```

Now, exit the container.

```bash
exit
```

This will return you to the usual Cloud9 shell prompt.

10. Push the docker container to the ECR repository.

This will upload the container to ECR where it can be pulled by other systems.

```bash
docker tag gromacs:latest $IMAGE_URI:latest
docker push $IMAGE_URI:latest
```

In the next steps, you will use automated CICD pipeline tools to build the container image and update ECR. In addition to the automation, the CICD pipeline provides a sandbox environment with the ability to limit access to AWS resources using [AWS IAM](https://aws.amazon.com/iam/) while having elevated privileges. 
