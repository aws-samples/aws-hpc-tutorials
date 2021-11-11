+++
title = "e. Auto execute pipeline"
date = 2021-09-30T10:46:30-04:00
weight = 70
tags = ["tutorial", "DeveloperTools", "CodePipeline", "CodeBuild", "CI/CD"]
+++

In this section, we will update the sample Dockerfile created earlier to automatically trigger the container build and update to Amazon ECR as part of the CodePipeline we created earlier.

We will modify the Dockerfile to run a Genomics workflow using [Nextflow](https://www.nextflow.io/index.html). 

We will go over the Nextflow architecture and job execution/orchestration more in the next lab. For now, we will go ahead and update the repository and see how the CICD pipeline works for your build.


1. First confirm you are in the **MyDemoRepo** repository:

```
pwd # should be MyDemoRepo
```

2. Update the Dockerfile to the following. This is an entrypoint script which can consume the link to an Amazon S3 bucket or a git repository from which to download the Nextflow pipeline and executes it.

{{% notice info %}}
The Nextflow command-line tool uses the JVM. Thus, we will install AWS open-source variant [Amazon Corretto](https://docs.aws.amazon.com/corretto/). Amazon Corretto is a no-cost, multiplatform, production-ready distribution of the Open Java Development Kit (OpenJDK). Corretto comes with long-term support that will include performance enhancements and security fixes. Amazon runs Corretto internally on thousands of production services and Corretto is certified as compatible with the Java SE standard. With Corretto, you can develop and run Java applications on popular operating systems, including Linux, Windows, and macOS.
{{% /notice %}}

```bash
cat > Dockerfile << EOF
FROM public.ecr.aws/amazoncorretto/amazoncorretto:8

RUN curl -s https://get.nextflow.io | bash \
 && mv nextflow /usr/local/bin/

RUN yum install -y git python-pip curl jq

RUN pip install --upgrade awscli

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

VOLUME ["/scratch"]

CMD ["/usr/local/bin/entrypoint.sh"]
EOF
```

3. Copy the entrypoint file (**entrypoint.sh**) from the S3 bucket and make it an executable
```bash
aws s3 cp s3://sc21-hpc-labs/entrypoint.sh .
chmod +x entrypoint.sh
```

4. Now we will update and push this file to the created codecommit repository
```bash
git add Dockerfile entrypoint.sh
git commit -m "Updated the Dockerfile to trigger Genomics workflow using Nextflow" 
git push origin main
```

5. In the AWS Management Console search bar, type and select **CodePipeline**. Click on the **MyDemoPipeline** that you created in the previous section. You should now see that the CodeCommit push above should have triggered the build via CodeBuild automatically. 
![AWS CodePipeline](/images/cicd/codepipeline-6.png)

6. Click on the **Details** deep link from the Build stage of the CodePipeline. This will take you to build logs from the CodeBuild project that you created:

![AWS CodePipeline](/images/cicd/codepipeline-7.png)
![AWS CodePipeline](/images/cicd/codepipeline-8.png)


7. Click on the **Tail logs** to see the on-going or completed build process. This is showcasing every step of the build process as provided in your **buildspec.yml** file.
![AWS CodePipeline](/images/cicd/codepipeline-9.png)

8. In addition to the build the pipeline is also pushing the built container image to the container registry in Amazon ECR. 






 
