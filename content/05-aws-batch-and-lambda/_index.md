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

You are familiar with AWS Batch and its benefits after finishing previous sections. Now we introduce AWS Lambda briefly as another compute service from AWS. You will also use [Amazon Simple Storage Service](https://aws.amazon.com/s3/) (Amazon S3) for file storage and S3 Event Notifications to start simulation jobs when the input files are uploaded to the S3 input bucket.

### About AWS Lambda
AWS Lambda is a serverless, event-driven compute service that lets you run code for virtually any type of application or backend service without provisioning or managing servers. You can trigger Lambda from over 200 AWS services and software as a service (SaaS) applications, and only pay for what you use.

In addition to start running applications within seconds of an trigger event, there are several more benefits by choosing AWS Lambda. Some of them are listed below:
1. Run code without provisioning or managing infrastructure
2. Event driven application execution
3. Built-in fault tolerance
4. Package and deploy functions as container images
5. Scale to match demand

You will also use Amazon Simple Storage Service (Amazon S3) for file storage and S3 Event Notifications to trigger simulation jobs to start when the input files are uploaded to the S3 input bucket.

### About Amazon Simple Storage Service (Amazon S3)
Amazon S3 is an object storage service offering industry-leading scalability, data availability, security, and performance. Customers of all sizes and industries can store and protect any amount of data for virtually any use case, such as data lakes, cloud-native applications, and mobile apps. With cost-effective storage classes and easy-to-use management features, you can optimize costs, organize data, and configure fine-tuned access controls to meet specific business, organizational, and compliance requirements.
