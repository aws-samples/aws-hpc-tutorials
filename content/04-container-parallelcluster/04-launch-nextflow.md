+++
title = "c. Run nextflow container"
date = 2019-09-18T10:46:30-04:00
weight = 50
tags = ["tutorial", "initialize", "ParallelCluster"]
+++

In this section, you will run a basic pipeline for quantification of genomic features from short read data implemented with [Nextflow](https://www.nextflow.io/).
Nextflow enables scalable and reproducible scientific workflows using software containers.

#### 1. Create a new container image with nextflow

Let's begning by creating a new version of the container image.

Change the Dockerfile with the nextflow container

```bash
cd $CONTAINER_WORKDIR
cat > Dockerfile << EOF
FROM nextflow/rnaseq-nf

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get --allow-releaseinfo-change update && apt-get update -y && apt-get install -y git python3-pip curl jq

RUN curl -s https://get.nextflow.io | bash \
 && mv nextflow /usr/local/bin/

RUN pip3 install --upgrade awscli
RUN chmod 755 /usr/local/bin/nextflow
EOF
```

Remove container cached layer

```bash
docker system prune -a -f
```

Build the new container image

```bash
docker build  -t ${CONTAINER_REPOSITORY_URI}:v2 -t ${CONTAINER_REPOSITORY_URI}:latest .
```


You have built your container image successfully, you will push the v2 local container image to the container repository you created earlier.

```bash
docker push ${CONTAINER_REPOSITORY_URI}:v2
docker push ${CONTAINER_REPOSITORY_URI}:latest
```

#### 2. Download the genomics workflow

```bash
cd /shared
git clone https://github.com/seqeralabs/nextflow-tutorial.git
cd nextflow-tutorial
```


#### 3. Run the Genomics Pipeline

```bash
srun singularity run --bind /shared/nextflow-tutorial:/mnt docker://`echo ${CONTAINER_REPOSITORY_URI}`:v2 nextflow run /mnt/script7.nf --reads '/mnt/data/ggal/*_{1,2}.fq' --outdir=/mnt
```

The output will be similar to this:

![Singularity run](/images/container-pc/singularity_nextflow.png)


You have now run a basic genomics pipeline and you won't need the cluster in the next labs.
The next section will go over how to delete your HPC Cluster.


<!-- ```bash
cat > Dockerfile << EOF
FROM nextflow/rnaseq-nf

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get --allow-releaseinfo-change update && apt-get update -y && apt-get install -y git python3-pip curl jq

RUN curl -s https://get.nextflow.io | bash \
 && mv nextflow /usr/local/bin/

RUN pip3 install --upgrade awscli
EOF
```


```bash
cat > Dockerfile << EOF
FROM public.ecr.aws/amazoncorretto/amazoncorretto:8

RUN yum install -y python3

RUN curl -O https://repo.anaconda.com/miniconda/Miniconda2-4.7.12-Linux-x86_64.sh

RUN bash ./Miniconda2-4.7.12-Linux-x86_64.sh -b -p /opt/conda
RUN ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh &&     echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc
RUN curl -O https://raw.githubusercontent.com/nextflow-io/rnaseq-nf/master/conda.yml && source ~/.bashrc && conda env update -n root -f conda.yml
EOF
``` -->