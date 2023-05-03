+++
title = "d. Create container repository"
date = 2019-09-18T10:46:30-04:00
weight = 145
tags = ["tutorial", "install", "AWS", "batch", "nextflow"]
+++

In this section, you will create a container repository on Amazon ECR and create a Docker container image.

Configure the AWS Region to be used by the AWS CLI.
```bash
export AWS_REGION=$(curl --silent http://169.254.169.254/latest/meta-data/placement/region)
aws configure set default.region ${AWS_REGION}
```

#### 1. Create the container repository

In this step, you will create a repository named `isc-container` using the Command Line Interface (CLI) in Amazon ECR.
Amazon ECR is a fully managed container registry offering high-performance hosting, so you can reliably deploy application images and artifacts anywhere.

```bash
CONTAINER_REPOSITORY_NAME="isc-container"
aws ecr create-repository --repository-name ${CONTAINER_REPOSITORY_NAME}
```

#### 2. Authenticate Docker with the Amazon ECR Repository

For Docker to interact with Amazon ECR, you will need to authenticate to the container registry of your AWS account.

To facilitate the Docker authentication, the commands provided below will:
- List the container repository and extract the URI of the container repository
- Extract the container registry URI: It looks like this *aws_account_id*.dkr.ecr.*region*.amazonaws.com
- Login Docker to Amazon ECR container registry

```bash
CONTAINER_REPOSITORY_URI=`aws ecr describe-repositories --query repositories[].[repositoryName,repositoryUri] | grep "/${CONTAINER_REPOSITORY_NAME}" | tr -d '"'`
ECR_URI=`echo $CONTAINER_REPOSITORY_URI | sed "s%/${CONTAINER_REPOSITORY_NAME}%%g" | tr -d '"'`
aws ecr get-login-password | docker login --username AWS --password-stdin ${ECR_URI}
```

#### 3. Create the Docker container

You will start by creating a directory that will host the container creation files, named  `container` in the shared directory.

```bash
CONTAINER_WORKDIR="/home/ec2-user/environment/container"
mkdir -p $CONTAINER_WORKDIR
cd $CONTAINER_WORKDIR
```

Copy the entrypoint file (entrypoint.sh) from the S3 bucket and make it an executable

```bash
aws s3 cp s3://isc-hpc-labs/entrypoint.sh .
chmod +x entrypoint.sh
```

Now let's create a Dockerfile with the nextflow container:
```bash
cat > Dockerfile << EOF
FROM nextflow/rnaseq-nf

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get --allow-releaseinfo-change update && apt-get update -y && apt-get install -y git python3-pip curl jq
RUN mkdir -p /usr/share/man/man1/
RUN apt install default-jre -y
RUN update-alternatives --list java
RUN mv /opt/conda/bin/java /opt/conda/bin/oldjava
RUN java -version

RUN wget https://github.com/nextflow-io/nextflow/releases/download/v22.10.8/nextflow
RUN chmod +x nextflow
RUN ./nextflow
RUN mv nextflow /usr/local/bin/

RUN pip3 install --upgrade awscli
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

VOLUME ["/scratch"]

CMD ["/usr/local/bin/entrypoint.sh"]
EOF
```

Build the new container image

```bash
docker build  -t ${CONTAINER_REPOSITORY_URI}:v1 -t ${CONTAINER_REPOSITORY_URI}:latest .
```

You have built your container image successfully, you will push the local container image to the container repository you created earlier.

```bash
docker push ${CONTAINER_REPOSITORY_URI}:v1
docker push ${CONTAINER_REPOSITORY_URI}:latest
```