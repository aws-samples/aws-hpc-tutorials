---
title: "AWS HPC Workshops"
date: 2019-09-18T10:50:17-04:00
draft: false
---

# SC20 Tutorial

Welcome to the **Best Practices for HPC in the Cloud** tutorial at SC 20 that will be delivered on November 9th 2020 and November 11th 2020. We are excited to virtually meet you, and look forward to answering your questions!
The website will be maintained after SC20, labs will also be available on https://www.hpcworkshops.com within a few weeks after the conference. No pre-work is necessary before the start of the tutorial.

### Important Information & Updates

{{% notice warning %}} **This website will be locked between November 8th 2020 through November 11th 2020 for the duration of the Tutorial**. Credentials to access this website will be communicated during the tutorial and on the tutorial slides. During the tutorial we will also communicate how you can get your credentials to log into your temporary AWS account to run the the hands-on labs.
{{% /notice %}}

### Need help?

- **Email**: you can contact us directly before, during and after the conference through this email: sc20tutorial@amazon.com
- **Gitter**: a Gitter room can be access for the duration of the tutorial which you can use to contact us for advice or help: https://gitter.im/aws-sc20/general

### Tutorial Content & Resources

#### Tutorial Resources

Before and during the tutorial you may be interested in going through the following sections:

- [**Agenda**](/01-hpc-overview/00-agenda.html) of the tutorial.
- [**FAQ**](/01-hpc-overview/01-updates.md) answers to common questions will be communicated here during the tutorial.
- [**Lab account**](/01-hpc-overview/03-access-aws.md) on how to access your lab account.

#### Presentations Slides

The last version of the Tutorial slides can be found [**through this link**](https://sc20slides.s3.amazonaws.com/SC20Tutorial-AWS-BestPracticesForHPCInTheCloud.pdf)

#### SC20 Hands-on Labs

Throughout the tutorial we will be going through the following labs:

1. [**Lab 0: Environment Prep**](/01-hpc-overview/00-agenda.html): It has to be done before running the first lab. It will grant you access to a web-based development environment and terminals. This ensure that every one can run the labs regardless of their operating system.
2. [**Lab 1: Create an HPC Cluster**](/03-hpc-aws-parallelcluster-workshop.html): You will be lead to create your first HPC system in the Cloud.
3. [**Lab 2: Serverless Computing**](/04-serverless.html): We will see how to build an API interface and submit jobs on Slurm using a serverless (Lambda) function.
4. [**Lab 3: Storage Lab**](/04-serverless.html): In this lab you will learn how to build a Lustre file system in the Cloud, no need to hold a PhD in storage for that.
5. [**Lab 4: Performance Monitoring at Scale**](/10-monitoring.html): This lab gives an overview of different methods and tools that can be used to assess application and infrastructure performance of your HPC cluster in the cloud.

#### Optional Labs

If you are interested to run additional labs don't hesitate to run one of these:

- [**Optional 1: Running Serverless Simulations**](/06-aws-batch.html): You will be introduced to AWS Batch which provides scheduling and orchestration functionalities to run jobs at scale in the cloud.
- [**Optional 2: Remote Visualization**](/07-nice-dcv.html): In this part we will introduce you to NICE DCV in order to visualize data residing in the cloud.
- [**Optional 3: Low Latency Network**](/08-efa.html): This part drives your through Elastic Fabric Adapter (EFA), a low latency network interface which can be used to run your tightly coupled workloads in the cloud. You may want to run the benchmark [GPCNET](https://github.com/netbench/GPCNET) as a stretch goal to collect the tail latency on EFA. *This lab cannot be tested during SC20 with your Event Engine Account due to the limited resources that these accounts provide*
- [**Optional 4: Distributed Machine Learning**](/09-ml-on-parallelcluster.html): This lab will enable you to run a Machine Learning distributed workload using the [PyTorch DistributedDataParallel](https://pytorch.org/tutorials/intermediate/ddp_tutorial.html) API.

#### Accessing Your Lab Account
Once you get your credentials during the tutorial, access your account through https://dashboard.eventengine.run.

{{% button href="https://github.com/aws-samples/aws-hpc-tutorials" icon="fas fa-bug" %}}Report an issue on GitHub{{% /button %}}
{{% button href="mailto:aws-hpc-workshops@amazon.com" icon="fas fa-envelope" %}}Contact AWS HPC Team{{% /button %}}
{{% button href="https://aws.amazon.com/hpc/" icon="fas fa-graduation-cap" %}}Learn more{{% /button %}}

