+++
title = "b. Create Docker and buildspec files"
date = 2021-09-30T10:46:30-04:00
weight = 40
tags = ["tutorial", "DeveloperTools", "CodeCommit"]
+++

In this section, you will create a Docker container for the application and a buildspec file in the CodeCommit repo created in the previous section

A [buildspec](https://docs.aws.amazon.com/codebuild/latest/userguide/build-spec-ref.html) is a collection of build commands and related settings in YAML format. This file is used by [AWS CodeBuild](https://docs.aws.amazon.com/codebuild/latest/userguide/welcome.html) to run a build. We will learn more about AWS CodeBuild and setup in the next section. 

1. Create a Docker container for the application in the CodeCommit repo
```bash
cat > Dockerfile << EOF
FROM public.ecr.aws/lambda/python:3.8

ADD script.py /

CMD python /script.py
EOF
```

2. Create a buildspec file to build and push the Docker container to [Amazon ECR](https://aws.amazon.com/ecr/)

```bash
cat > buildspec.yml << EOF
version: 0.2

phases:
  pre_build:
    commands:
      - echo Logging in to Amazon ECR...
      - aws --version
      - $(aws ecr get-login --region $AWS_DEFAULT_REGION --no-include-email)
      - IMAGE_TAG=$(echo $CODEBUILD_RESOLVED_SOURCE_VERSION | cut -c 1-8)
      - echo IMAGE TAG $IMAGE_TAG

  build:
    commands:
      - echo Build started on `date`
      - echo Building the Docker image...
      - docker build -t $REPOSITORY_URI:latest .
      - docker tag $REPOSITORY_URI:latest $REPOSITORY_URI:$IMAGE_TAG

  post_build:
    commands:
      - echo Build completed on `date`
      - echo Pushing the Docker images...
      - docker push $REPOSITORY_URI:latest
      - docker push $REPOSITORY_URI:$IMAGE_TAG

EOF
```

3. Commit & Push the created files to the CodeCommit repo
```bash
cd MyDemoRepo
```

```bash
git add Dockerfile buildspec.yml
git commit -m "Created Dockerfile and buildspec file"
git push
```

