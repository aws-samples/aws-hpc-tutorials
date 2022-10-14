+++
title = "b. Create a repo in CodeCommit"
date = 2021-09-30T10:46:30-04:00
weight = 40
tags = ["tutorial", "DeveloperTools", "CodeCommit"]
+++

1. Confirm you are in the **MyDemoRepo** directory:

```
cd ~/environment/MyDemoRepo
```

2. Make this directory into a Git repository, and add an initial commit containing the files we created in the previous step.

```bash
git init # initializes the git repository in this directory
git branch -m main # name the default brainch 'main'
git add Dockerfile spack.yaml # stage our files for commit
git commit -m "Created Dockerfile and spack files" # create a point-in-time commit
```

Next, you will use the AWS Command Line Interface (CLI) to create a Git repository in [AWS CodeCommit](https://aws.amazon.com/codecommit/) where we can push our local git repository.

3. Next create your CodeCommit Repo:

[AWS CodeCommit](https://aws.amazon.com/codecommit/) is a secure, highly scalable, managed source control service that hosts private Git repositories.

```bash
aws codecommit create-repository --repository-name MyDemoRepo --repository-description "My demonstration repository" --tags Team=SC22
```

4. Get repository URL:

```bash
REPOURL=$(aws codecommit get-repository --repository-name MyDemoRepo --query repositoryMetadata.cloneUrlHttp --output text ) 
echo $REPOURL
```

Verify **echo $REPOURL** outputs a repo url like **https://git-codecommit.\<region\>.amazonaws.com/v1/repos/MyDemoRepo**

5. Add the CodeCommit as the **origin** remote for our git repository:

```bash
git remote add origin $REPOURL
```

Verify that the git remote is set correctly:

```bash
$ git remote -v
# expected output
# origin	https://git-codecommit.<region>.amazonaws.com/v1/repos/MyDemoRepo (fetch)
# origin	https://git-codecommit.<region>.amazonaws.com/v1/repos/MyDemoRepo (push)
```

6. Push the local Git changes to CodeCommit:

```bash
git push -u origin main
```

Verify that the CodeCommit and local repositories are synchronized with:

```bash
$ git fetch && git status
# expected output
# ...
# On branch main
# Your branch is up to date with 'origin/main'.
# ...
```
