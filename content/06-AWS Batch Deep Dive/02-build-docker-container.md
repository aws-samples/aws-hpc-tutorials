+++
title = "c. Build A Container With Docker"
date = 2019-09-18T10:46:30-04:00
weight = 30
tags = ["tutorial", "install", "AWS", "batch", "Docker"]
+++

In this step, you will create a **Dockerfile** file that contains the steps to build and test a container image on your Cloud9 instance. 

1. Create a new working directory by executing the following commands in the Cloud9 terminal.
```bash
mkdir single
cd single
```
You should now see a new directory named "single" appear in the file navigation panel on the left side of the Cloud9 IDE.

2. Right click on the icon for this directory and select **New File** and name it **Dockerfile**. 
3. Double click on the icon of the **Dockerfile** to open the file in a new Cloud9 editor. 
4. Copy and paste the following contents into **Dockerfile**:

```bash
FROM public.ecr.aws/amazonlinux/amazonlinux:latest
RUN yum -y update
RUN amazon-linux-extras install epel -y
RUN yum -y install stress-ng
RUN echo $'#!/bin/bash\n\
echo "Passing the following arguments to stress-ng: $STRESS_ARGS"\n\
/usr/bin/stress-ng $STRESS_ARGS' >> /docker-entrypoint.sh 
RUN chmod 0744 /docker-entrypoint.sh
RUN cat /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
```

4. Save the file.
   
This is the recipie to build your container. It is based on the latest version of Amazon Linux 2 and installs the "stress-ng" utility, available from the EPEL repository, which is the computationally intensive task that you will be running throughput this workshop. Note how it creates a wrapper script called docker-entrypoint.sh to be executed when the container starts. Note also the environment variable, $STRESS_ARGS, that is used to pass command-line options to the stress-ng executable.

1. Build a container named "stress-ng" from your Dockerfile by excuting the following command:

```bash
docker build -t stress-ng .
```

This process takes a little time and once complete the line of output should say: "Successfully tagged stress-ng:latest"

3. List the contents of the local Docker image repository.

```bash
docker images
```
You should see your "stress-ng" image listed with the tag "latest".

4. You can test your container by running it locally on your Cloud9 instance using the following command.

```bash
docker run -e STRESS_ARGS="--cpu 0 --cpu-method fft --timeout 30s --times" -i stress-ng
```
This program runs a stress test on the CPU and you should see the command run for a little over 30 seconds and report successful execution along with its CPU usage. 

Note how the set of command line options controlling the test to perform are passed to the stress-ng executable via the STRESS_ARGS environment variable, which in this case is passed to the running container using the docker -e option.
