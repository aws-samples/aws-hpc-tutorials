+++
title = "a. Create a repo in CodeCommit"
date = 2021-09-30T10:46:30-04:00
weight = 40
tags = ["tutorial", "DeveloperTools", "CodeCommit"]
+++

1. Confirm you are in the **MyDemoRepo** repository:

```
pwd # should be MyDemoRepo
```

2. Make this directory into a Git repository, and add an initial commit containing the files we created in the previous step.

```bash
git init # initializes the git repository in this directory
git branch -m main # name the default brainch 'main'
git add Dockerfile spack.yaml # stage our files for commit
git commit -m "Created Dockerfile and spack files" # create a point-in-time commit
```

Next, we'll use the AWS Command Line Interface (CLI) to create a Git repository in [AWS CodeCommit](https://aws.amazon.com/codecommit/) where we can push our local git repository.

3. Set AWS Region

```bash
export AWS_DEFAULT_REGION=$(curl --silent http://169.254.169.254/latest/meta-data/placement/region)
```

This will set the default region to be used for subsequent aws commands.

4. Next create your CodeCommit Repo:

[AWS CodeCommit](https://aws.amazon.com/codecommit/) is a secure, highly scalable, managed source control service that hosts private Git repositories.

```bash
aws codecommit create-repository --repository-name MyDemoRepo --repository-description "My demonstration repository" --tags Team=SC22
```

5. Get repository URL:

```bash
REPOURL=$(aws codecommit get-repository --repository-name MyDemoRepo --query repositoryMetadata.cloneUrlHttp --output text ) 
echo $REPOURL
```

Verify **echo $REPOURL** outputs a repo url like **https://git-codecommit.\<region\>.amazonaws.com/v1/repos/MyDemoRepo**

6. Add the CodeCommit as the **origin** remote for our git repository:

```bash
git remote add origin $REPOURL
```

Verify that the git remote is set correctly:

```bash
$ git remote -v
origin	https://git-codecommit.<region>.amazonaws.com/v1/repos/MyDemoRepo (fetch)
origin	https://git-codecommit.<region>.amazonaws.com/v1/repos/MyDemoRepo (push)
```

7. Push the local Git commit to CodeCommit:

```bash
git push -u origin main
```

Verify that the CodeCommit and local repositories are synchronized with:

```bash
$ git status
On branch main
Your branch is up to date with 'origin/main'.
...
```
