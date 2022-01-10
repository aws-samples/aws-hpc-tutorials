+++
title = "c. Build A Container With Docker"
date = 2019-09-18T10:46:30-04:00
weight = 30
tags = ["tutorial", "install", "AWS", "batch", "Docker"]
+++

In this step, you will create a simple "Dockerfile" with the specifications for a container and then use Docker commands to build and test a container image on your Cloud9 instance. 

1. Open a new file in the Cloud9 editor named "Dockerfile" and cut and paste the following contents:

```bash
FROM public.ecr.aws/amazonlinux/amazonlinux:latest
RUN yum -y update
RUN amazon-linux-extras install epel -y
RUN yum -y install stress-ng
RUN echo $'#!/bin/bash\n\
echo "Passing the following arguments to stress-ng: $STRESS_ARGS"\n\
/usr/bin/stress-ng $STRESS_ARGS' \n\ >> /docker-entrypoint.sh 
RUN chmod 0744 /docker-entrypoint.sh
RUN cat /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
```
This Docker file uses the latest version of Amazon Linux 2, installs the stress-ng executable from the EPEL repository, and creates a wrapper script called docker-entrypoint.sh that is executed when the container starts. This script uses an environment variable, $STRESS_ARGS, to pass command-line options to the stress-ng executable.

1. Build a container with the tag "stress-ng" from your Dockerfile by excuting the following command:

```bash
docker build -t stress-ng .
```

If all went well you should see output similar to: "Successfully tagged stress-ng:latest"

3. List the contents of the local Docker image repository.

```bash
docker images
```
You should see your "stress-ng" image listed with the tag "latest".

4. You can test the container you just built by running it locally on your Cloud9 instance using the following command.

```bash
docker run -e STRESS_ARGS="--cpu 0 --cpu-method fft -t 30s --times" -i stress-ng
```
You should see the command run for a little over 30 seconds and report successful execution along with its CPU usage percentages. 

Note how the set of commandline options controlling the test are passed to the stress-ng executable via the STRESS_ARGS environment variable, which is passed to the running container using the docker -e option.