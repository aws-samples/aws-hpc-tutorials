+++
title = "a. Create a repo in CodeCommit"
date = 2021-09-30T10:46:30-04:00
weight = 30
tags = ["tutorial", "DeveloperTools", "CodeCommit"]
+++

{{% notice info %}}This lab requires an AWS Cloud9 IDE. If you do not have an AWS Cloud9 IDE set up, complete sections *a. Sign in to the Console* through *d. Work with the AWS CLI* in the [**Getting Started in the Cloud**](/02-aws-getting-started.html) workshop.
{{% /notice %}}

1. In the AWS Management Console search bar, type and select **Cloud9**.

2. Choose **open IDE** for the Cloud9 instance set up previously. It may take a few moments for the IDE to open. AWS Cloud9 stops and restarts the instance so that you do not pay compute charges when no longer using the Cloud9 IDE.

3. Next, we'll use the AWS CLI to create a Git repository in [AWS CodeCommit](https://aws.amazon.com/codecommit/) and clone the empty repo in your Cloud9 environment.

1. First verify AWS CLI is installed:

```bash
aws --version
```

2. Next create your CodeCommit Repo:

AWS CodeCommit is a secure, highly scalable, managed source control service that hosts private Git repositories.

```bash
aws codecommit create-repository --repository-name MyDemoRepo --repository-description "My demonstration repository" --tags Team=SC21
```

3. Get repository URL to clone:

```bash
REPOURL=$(aws codecommit get-repository --repository-name MyDemoRepo --query repositoryMetadata.cloneUrlHttp --output text)
echo $REPOURL
```

Verify `echo $REPOURL` outputs a repo url like: `https://git-codecommit.<region>.amazonaws.com/v1/repos/MyDemoRepo`

4. Clone the repository in your Cloud9 terminal and cd into it:

```bash
$ git clone $REPOURL
Cloning into 'MyDemoRepo'...
remote: Counting objects: 4, done.
Unpacking objects: 100% (4/4), 681 bytes | 227.00 KiB/s, done.
$ cd MyDemoRepo/
```

5. Now let's update the default branch from **master** to **main**:
```
$ git branch -m master main
```
