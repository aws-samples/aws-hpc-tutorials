---
title: "Container building automation"
date: 2021-09-29
weight: 50
pre: "<b>Lab III ⁃ </b>"
tags: ["CI/CD", "AWS Developer Tools", "DevOps"]
---

![devops_logo](/images/cicd/devops-logo.png)

HPC resources have complex and dynamic software needs that are challenging to manage and maintain. Users often want the latest software available for their research and development which drives the need for frequent installation and updates. Administrators currently address these complex software needs with package managers such as Lmod, Easybuild or Spack. However, even with these tools software management in an HPC environment includes manual and error-prone steps. Continuous integration, delivery, and deployment (CICD) is widely used in DevOps communities, as it allows to deploy rapidly-changing hardware and software resources. One can build a CICD pipeline to automatically build and/or deploy their HPC application either in the form of containers or as a custom image with all the software dependencies installed. Integrating CICD practices into HPC workflows increases the potential for delivering high quality and reliable software. 

In this lab, you are introduced to [AWS Developer Tools](https://aws.amazon.com/products/developer-tools/) and how to use services like AWS CodeCommit, AWS CodeBuild and AWS CodePipeline to automate application deployment with containers, CI/CD pipelines and container orchestrators. 

You will be deploying the below architecture as part of this lab:

![AWS CICD](/images/cicd/cicd-pipeline-arch.png)



This lab includes the following steps:

1. Create a repository in AWS CodeCommit
2. Create a build environment using AWS CodeBuild
3. Create a pipeline using AWS CodePipeline
4. Automate the build process with repository update



[AWS Developer Tools](https://aws.amazon.com/products/developer-tools/) provides a list of services to host code, build, test, and deploy your applications quickly and effectively.  AWS services offered as part of the AWS Developer Tools suite helps remove the undifferentiated heavy lifting associated with DevOps adaptation and software development. You can build a continuous integration and delivery capability without managing servers or build nodes, and leverage Infrastructure as code (IaC) to provision and manage your cloud resources in a consistent and repeatable manner.

##### Benefits
+ **Minimize downtime**

	Build highly available applications on a resilient cloud infrastructure and enable your teams to respond, adapt, and recover quickly from unexpected events.

+ **Automate CI/CD pipelines & Release software faster**

	Remove error-prone manual processes and eliminate the need to babysit software releases. Use software release pipelines that encompass build, test, and deployment.

+ **Increase developer productivity**

	Manage services, provision resources, and automate development tasks without switching context or leaving your editor.

+ **Monitor operations**

	Build an observability dashboard to gain instant and continuous insight into your system’s operations.

+ **Test and automate infrastructure**

	Combine Infrastructure as code with version control and automated, continuous integration to bring scalability and consistency to provisioning and management.

{{% notice info %}}This lab requires an AWS Cloud9 IDE. If you do not have an AWS Cloud9 IDE set up, complete the **[Preparation](/02-aws-getting-started.html)** section of the workshop.
{{% /notice %}}


