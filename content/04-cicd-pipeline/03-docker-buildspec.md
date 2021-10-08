+++
title = "b. Create Docker and buildspec files"
date = 2021-09-30T10:46:30-04:00
weight = 40
tags = ["tutorial", "DeveloperTools", "CodeCommit"]
+++

In this section, you will create a Docker container for the application and a buildspec file in the CodeCommit repo created in the previous section

A [buildspec](https://docs.aws.amazon.com/codebuild/latest/userguide/build-spec-ref.html) is a collection of build commands and related settings in YAML format. This file is used by [AWS CodeBuild](https://docs.aws.amazon.com/codebuild/latest/userguide/welcome.html) to run a build. We will learn more about AWS CodeBuild and setup in the next section. 

1. Create a Docker container for the application in the CodeCommit repo. We're going to use the [Python 3.8 Lambda container](https://gallery.ecr.aws/lambda/python) from ECR. This container contains all the required components to run on AWS Lambda. You can find other runtime environments on the [ECR Lambda](https://gallery.ecr.aws/lambda) page.

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
      - \$(aws ecr get-login --region \$AWS_DEFAULT_REGION --no-include-email)
      - IMAGE_TAG=\$(echo \$CODEBUILD_RESOLVED_SOURCE_VERSION | cut -c 1-8)
      - echo IMAGE TAG \$IMAGE_TAG

  build:
    commands:
      - echo Build started at \$(date)
      - echo Building the Docker image...
      - docker build -t \$REPOSITORY_URI:latest .
      - docker tag \$REPOSITORY_URI:latest \$REPOSITORY_URI:\$IMAGE_TAG

  post_build:
    commands:
      - echo Build completed at $(date)
      - echo Pushing the Docker images...
      - docker push \$REPOSITORY_URI:latest
      - docker push \$REPOSITORY_URI:\$IMAGE_TAG

EOF
```

3. Create a file `script.py` with a simple hello world:

```bash
cat > script.py << EOF
# Hello World Python Script

print('Hello World!')
EOF
```

4. Commit & Push the created files to the CodeCommit repo

```bash
git add Dockerfile buildspec.yml script.py
git commit -m "Created Dockerfile and buildspec file"
git push origin main
```

5. Now update the default Codecommit branch to `main`:

```bash
aws codecommit update-default-branch --repository-name MyDemoRepo --default-branch-name main
```