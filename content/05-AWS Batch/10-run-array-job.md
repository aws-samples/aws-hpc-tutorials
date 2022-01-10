+++
title = "j. Run an Array Job"
date = 2019-09-18T10:46:30-04:00
weight = 110
tags = ["tutorial", "install", "AWS", "batch", "packer"]
+++


In this step you will create a new container that generates a file with a set of different stress tests. You will run an array job with this container and each member task will perform a different test based on its array index. 


### Automation of the container build and push processes

Since you are going to be building and pushing more container images, it's worth simplifying and automating the container build pipeline by creating some shell scripts that (a) create a new named ECR repository, and (b) build the container image based on the Dockerfile and push it to the named repository.

Create a directory for your new scripts.

```bash
mkdir ~/bin
```

Execute the following commands to build the script that creates a named ECR repository.

```bash
cat > ~/bin/create_repo.sh << EOF
#!/bin/bash
echo ${1}
aws ecr create-repository --repository-name \${1}
EOF
chmod +x ~/bin/create_repo.sh
```

Execute the following commands to create the script that builds a container based on the Dockerfile in the local directory and pushes it to the named ECR repository.
```bash
cat > ~/bin/build_container.sh << EOF
#!/bin/bash
echo \${1}
export AWS_REGION=\$(curl --silent http://169.254.169.254/latest/meta-data/placement/region)
export AWS_ACCOUNT=\$(curl -s 169.254.169.254/latest/meta-data/identity-credentials/ec2/info | jq -r '.AccountId')
aws ecr get-login-password --region \${AWS_REGION} | docker login --username AWS --password-stdin \${AWS_ACCOUNT}.dkr.ecr.\${AWS_REGION}.amazonaws.com
docker build -t \${1} .
docker tag \${1}:latest \${AWS_ACCOUNT}.dkr.ecr.\${AWS_REGION}.amazonaws.com/\${1}:latest
docker push \${AWS_ACCOUNT}.dkr.ecr.\${AWS_REGION}.amazonaws.com/\${1}:latest
EOF
chmod +x ~/bin/build_container.sh
```



### Build a new container for your array job


1. Create a new subdirectory called array in which we will build a new container for our array job.

```bash
mkdir ~/array
cd ~/array
```

2. Copy and paste the following into a new file named Dockerfile in the array directory.

```text
FROM public.ecr.aws/amazonlinux/amazonlinux:latest
RUN yum -y update
RUN amazon-linux-extras install epel -y
RUN yum -y install stress-ng

### Build mktests.sh
RUN echo $'#!/bin/bash\n\
FILE=/stress-tests.txt\n\
rm $FILE 2>/dev/null\n\
COUNT=0\n\
for II in `stress-ng --cpu-method which 2>&1`\n\
do\n\
    if [ $COUNT -gt  5 ]; then\n\
        echo "--cpu 0 -t 120s --times --cpu-method $II" >> $FILE\n\
    fi\n\
    COUNT=`expr $COUNT + 1`\n\
done' >> /mktests.sh
RUN chmod 0744 /mktests.sh
RUN cat /mktests.sh

RUN echo $'#!/bin/bash\n\
/mktests.sh\n\
STRESS_ARGS=`sed -n $((AWS_BATCH_JOB_ARRAY_INDEX + 1))p /stress-tests.txt`\n\
echo "Passing the following arguments to stress-ng: $STRESS_ARGS"\n\
/usr/bin/stress-ng $STRESS_ARGS' \n\ >> /docker-entrypoint.sh 
RUN chmod 0744 /docker-entrypoint.sh
RUN cat /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
```

Note some of the changes from the last Dockerfile:
- This version generates a script called /mktests.sh container.
- It calls this script from the docker-entrypoint.sh script when the container runs and generates a file called /stress-tests.txt inside the running container.
- This file will be used by each array task to execute a different command by selecting the corresponding line based on its array index variable and setting their STRESS_ARGS environment variable accordingly.


3. Create a new repository for your job array container in Amazon ECR. Note that you are using a new name here since this container has different purpose and functionality. A repository has a 1:1 relationship with a container, however each repository can have multiple versions (tags).

```bash
~/bin/create_repo.sh stress-ng-array
```

4. Build and push an image of your new job array container.

```bash
~/bin/build_container.sh stress-ng-array
```

You just defined, built and pushed the new stress-ng-array container in three simple steps.


Let's take a closer look at what that new container does.

Note that the following steps are all accomplished by the Dockerfile above and as such the following steps do not need to be directly executed, however feel free to copy and paste their contents and execute them on your Cloud9 instance to investigate how they work. 

A script called /mktests.sh is generated inside your container with the following contents:
```bash
#!/bin/bash
FILE=stress-tests.txt
rm $FILE 2>/dev/null
COUNT=0
for II in `stress-ng --cpu-method which 2>&1`
do
    # Discard the first 5 words.
    if [ $COUNT -gt  5 ]; then 
        echo "--cpu 0 -t 120s --metrics --cpu-method $II" >> $FILE
    fi
    COUNT=`expr $COUNT + 1`
done
```

When executed that script creates a file of different tests called /stress-tests.txt with contents similar to the following:
```text
--cpu 0 -t 120s --metrics --cpu-method ackermann
--cpu 0 -t 120s --metrics --cpu-method bitops
--cpu 0 -t 120s --metrics --cpu-method callfunc
--cpu 0 -t 120s --metrics --cpu-method cdouble
--cpu 0 -t 120s --metrics --cpu-method cfloat
...
```

Each line of this file is a different test that can be passed to the stress-ng program via the STRESS_ARGS environment variable. Each member task of the array job will execute the stress-ng command with a different set of command line flags (i.e. a different line of this file) corresponding to the value of its array index variable plus one, i.e. $((AWS_BATCH_JOB_ARRAY_INDEX + 1)) since the array index starts a zero and file line numbers begin at one.


### Create a job definition for your array job
Execute the following commands to create and register a **jobDefinition** for your array job.
```bash
ARRAY_REPO=$(aws ecr describe-repositories --repository-names stress-ng-array --output text --query 'repositories[0].[repositoryUri]')
cat > stress-ng-array-job-definition.json << EOF
{
    "jobDefinitionName": "stress-ng-array-job-definition",
    "type": "container",
    "containerProperties": {
        "image": "${ARRAY_REPO}",
        "vcpus": 1,
        "memory": 1024
    },
    "retryStrategy": { 
        "attempts": 2
    }
}
EOF
aws batch register-job-definition --cli-input-json file://stress-ng-array-job-definition.json
```

### Submit an array job
Execute the following commands to (a) create a file of job options that references the previously registered **jobDefinition** and provides additional parameters such as the **jobName**, **array size** and destination **jobQueue**; and then (b) execute the job by passing this option file on the command line.

```bash
cat <<EOF > ./stress-ng-array-job.json
{
  "jobName": "stress-ng-array",
  "jobQueue": "stress-ng-queue",
  "arrayProperties": {
    "size": 8
  },
  "jobDefinition": "stress-ng-array-job-definition"
}
EOF
aws batch submit-job --cli-input-json file://stress-ng-array-job.json
```
You can observe the status changes and execution of your job at the [**AWS Batch dashboard**](https://console.aws.amazon.com/batch/).

Note that when you click on an individual array job and view its details you will see multiple entries for each **job index** which are the individual member tasks of the job array. 
![AWS Batch](/images/aws-batch/array-job-1.png)
You can view the individual **CloudWatch** log streams for each member task.
![AWS Batch](/images/aws-batch/array-job-2.png)

### Submit an array job using command-line options.

Alternatively you can provide all of the paremeters for a job on the command line.
```bash
aws batch submit-job --job-name job-array --job-queue stress-ng-queue --job-definition stress-ng-array-job-definition --array-properties size=6 
```

It is often convenient to use environment variables to parameterise command lines.

```bash
#### Edit these environment variables.
export JOB_NAME=job-array-5
export JOB_ARRAY_SIZE=5
export JOB_QUEUE=stress-ng-queue
export JOB_DEFINITION=stress-ng-array-job-definition
aws batch submit-job --job-name ${JOB_NAME} --job-queue ${JOB_QUEUE} --job-definition ${JOB_DEFINITION} --array-properties size=${JOB_ARRAY_SIZE} 
```



To learn more about job arrays, see [Tutorial: Using the Array Job Index to Control Job Differentiation](https://docs.aws.amazon.com/batch/latest/userguide/array_index_example.html).

