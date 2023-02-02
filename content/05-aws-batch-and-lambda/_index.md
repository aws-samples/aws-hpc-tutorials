---
title: "Simulations with AWS Batch and Lambda"
date: 2023-01-19T17:13:20-05:00
weight: 50
pre: "<b>III ⁃ </b>"
tags: ["HPC", "Overview", "Batch", "Lambda"]
---

Cloud computing gains its popularity as a result of growing demand on compute power and the benefit of improving productivity with overall cost reductions.

This workshop provides step-by-step instructions to build a distributed system with a cloud-native event-event driven architecture. [AWS Lambda](https://aws.amazon.com/lambda/) is for jobs requiring fast turnaround and Batch is chosen to scale beyond thousands of vCPUs efficiently and cost-effectively. You will calculate American option price with Monte Carlo simulations using the QuantLib open-source software library to illustrate workloads requiring intensive compute resources can be done timely with the system.

You are familiar with AWS Batch and its benefits after finishing previous sections. Now we introduce AWS Lambda briefly as another compute service from AWS.

### About AWS Lambda
AWS Lambda is a serverless, event-driven compute service that lets you run code for virtually any type of application or backend service without provisioning or managing servers. You can trigger Lambda from over 200 AWS services and software as a service (SaaS) applications, and only pay for what you use.

In addition to start running applications within seconds of an trigger event, there are several more benefits by choosing AWS Lambda. Some of them are listed below:
1. Run code without provisioning or managing infrastructure
2. Automatically respond to code execution requests
3. Built-in fault tolerance
4. Package and deploy functions as container images
5. Automatic scaling

