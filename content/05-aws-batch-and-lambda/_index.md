---
title: "Simulations with AWS Batch and Lambda"
date: 2023-01-19T17:13:20-05:00
weight: 50
pre: "<b>III ⁃ </b>"
tags: ["HPC", "Overview", "Batch", "Lambda"]
---

This workshop provides step-by-step instructions to setup an event-driven batch architecture for short and long running jobs.

[AWS Batch](https://aws.amazon.com/batch/) lets developers, scientists, and engineers efficiently run hundreds of thousands of batch and ML computing jobs while optimizing compute resources. It is ideal for jobs lasting >5 minutes

[AWS Lambda](https://aws.amazon.com/lambda/) is a serverless compute service that lets you run code without provisioning or managing servers. It has the ability execute code up to 15 minutes and is ideal for batch jobs <5 minutes.

In this workshop, you will learn to take advantage of the large scale of AWS Batch for long running jobs as well as AWS Lambda for short running jobs. As an example, you will calculate American option price with Monte Carlo simulations using the [QuantLib](https://www.quantlib.org/) open-source software library to illustrate workloads requiring intensive compute resources can be done timely with the system.

