+++
title = "f. Conclusion"
date = 2021-09-30T10:46:30-04:00
weight = 80
tags = ["tutorial", "DeveloperTools", "CodePipeline", "CodeBuild", "CI/CD"]
+++

{{% notice warning %}}
The beginning of Lab IV involves an EKS cluster creation step that you will need to start **before** the break.
*Please continue to Lab IV through step **b. Create EKS cluster** before continuing to the break.*
You do not need to wait for EKS cluster creation to finish.
{{% /notice %}}

Congratulations! You built a CI/CD pipeline uisng CodePipeline. 

Your pipeline began with code in CodeCommit, built a Docker container and pushed the image to Elastic Container Registry (ECR) using CodeBuild.

In the next lab, you will learn about container orchestration and how to deploy your container on Kubernetes using [Amazon EKS](https://aws.amazon.com/eks/) to run a tightly-coupled GROMACS simulation.
