---
title: "Create a CI/CD pipeline"
date: 2021-09-29
weight: 50
pre: "<b>IV ⁃ </b>"
tags: ["CI/CD", "AWS Developer Tools", "DevOps"]
---

![devops_logo](/images/cicd/devops-logo.png)

[AWS Developer Tools](https://aws.amazon.com/products/developer-tools/) provides a list of services to host code, build, test, and deploy your applications quickly and effectively.  AWS services offered as part of the AWS Developer Tools suite helps remove the undifferentiated heavy lifting associated with DevOps adaptation and software development. You can build a continuous integration and delivery capability without managing servers or build nodes, and leverage Infrastructure as Code to provision and manage your cloud resources in a consistent and repeatable manner.

### Benefits
#### Minimize downtime
Build highly available applications on a resilient cloud infrastructure and enable your teams to respond, adapt, and recover quickly from unexpected events.

#### Automate CI/CD pipelines & Release software faster

Remove error-prone manual processes and eliminate the need to babysit software releases. Use software release pipelines that encompass build, test, and deployment.

#### Increase developer productivity

Manage services, provision resources, and automate development tasks without switching context or leaving your editor.

#### Monitor operations

Build an observability dashboard to gain instant and continuous insight into your system’s operations.

#### Test and automate infrastructure

Combine infrastructure as code (IaC) with version control and automated, continuous integration to bring scalability and consistency to provisioning and management.

{{% notice info %}}This lab requires an AWS Cloud9 IDE. If you do not have an AWS Cloud9 IDE set up, complete sections *a. Sign in to the Console* through *d. Work with the AWS CLI* in the [**Getting Started in the Cloud**](/02-aws-getting-started.html) workshop.
{{% /notice %}}

In this lab, you are introduced to [AWS Developer Tools](https://aws.amazon.com/products/developer-tools/) and how to use services like AWS CodeCommit, AWS CodeBuild and AWS CodePipeline to automate application deployment with containers, CI/CD pipelines and container orchestrators . This workshop includes the following steps:

- Create a repository in AWS CodeCommit
- Create a build environment using AWS CodeBuild
- Create a pipeline using AWS CodePipeline
- Automate the build process with repo update
