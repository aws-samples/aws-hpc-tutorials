+++
title = "k. Job Dependencies"
date = 2019-09-18T10:46:30-04:00
weight = 110
tags = ["tutorial", "install", "AWS", "batch", "Docker"]
+++

In this step you will implement a more realistic workflow scenario that employs multiple jobs, shared data, and implements a job dependency as an example of a common Leader/Follower pattern.

You will essentially split the work of from the previous array example into two separate jobs:
- A **Leader** job will define the work to be carried out and write this information to an Amazon S3 bucket. This is accomplished by executing the mktests.sh script (as described in the previous array axample) and uploading the resulting stress-tests.txt output file to the specified bucket.
- Each member task of a **Follower** array job will then retrieve the stress-tests.txt file from the S3 bucket and use it as input, determining which test to carry out based on its array index in a similar manner to the previous array job. Each Follower task will also write its output to a separate file in the specified S3 bucket.

You will submit the two jobs and specify a dependency such that the Leader job runs first and the Follower array job will only start upon successful completion of the Leader job.


### Create an S3 Bucket and IAM Role 

You will use [**AWS CloudFormation**](https://aws.amazon.com/cloudformation/) to automate the creation of an S3 bucket and an IAM Role with limited read and write permissions to the bucket for use by the Leader and Follower jobs. 


1. Create a new directory called **dependency** to store the configuration files for this stage of the workshop.
```bash
mkdir ~/environment/dependency
cd ~/environment/dependency
```
2. Right click on this directory in the Cloud9 file broswer to create a new file named **s3policy.yaml** and copy and paste the following contents:

```yaml
# Use as follow:
#   aws cloudformation create-stack --stack-name 'BatchWorkshop' \
#                                   --template-body file://s3policy.yaml \
#                                   --capabilities "CAPABILITY_IAM"
AWSTemplateFormatVersion: '2010-09-09'
Description: 'Create an S3 bucket and an ECS Task Role to access this bucket
  in order to write configuration data, read command arguments and write output data.'

Metadata:
  'AWS::CloudFormation::Interface':
    ParameterGroups:
    - Label:
        default: 'Parent Stacks'
      Parameters:
      - BucketName
Parameters:
    BucketName:
      Description: 'Optional name of the bucket.'
      Type: String
      Default: ''
Conditions:
  HasBucketName: !Not [!Equals [!Ref BucketName, '']]

Resources:
  # Set up a Role for Batch job execution.
  JobExecutionRole:
    Type: AWS::IAM::Role
    Properties:
      AssumeRolePolicyDocument:
        Version: '2012-10-17'
        Statement:
          - Effect: Allow
            Principal:
              Service:
                - ecs-tasks.amazonaws.com
            Action:
              - sts:AssumeRole
      ManagedPolicyArns:
        - arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy

  # Set up an S3 Bucket, Policy and Role for tasks to read/write from/to the output bucket
  Bucket:
    Type: AWS::S3::Bucket
    Properties:
      BucketName: !If [HasBucketName, !Ref BucketName, !Ref 'AWS::NoValue']
      
  # Set up a Policy that allows access to the S3 Bucket and attach it to the Role.
  BucketPolicy:
    Type: AWS::IAM::Policy
    Properties:
      PolicyName: BucketPolicy
      PolicyDocument:
          Version: 2012-10-17
          Statement:
          - Effect: Allow
            Action:
              - 's3:AbortMultipartUpload'
              - 's3:GetBucketLocation'
              - 's3:GetObject'
              - 's3:ListBucket'
              - 's3:ListBucketMultipartUploads'
              - 's3:PutObject'
            Resource:
              - !Join [ "", [ "arn:aws:s3:::", !Ref 'Bucket' ] ]
              - !Join [ "", [ "arn:aws:s3:::", !Ref 'Bucket' , "/*" ] ]

      Roles:
        - !Ref 'JobExecutionRole'       

Outputs:
  JobExecutionRole:
    Description: ECS Task Execution Role for AWS Batch Jobs
    Value: !Ref JobExecutionRole
  Bucket:
    Description: Bucket in which configuration and output will be written
    Value: !Ref Bucket
  BucketPolicy:
    Description: ECS Task Policy for S3 access to S3 Bucket
    Value: !Ref BucketPolicy
```
3. Save the **s3policy.yaml** file.
4. Copy, paste and execute the following command in a terminal session on your Cloud9 instance.
```bash
cat > cfn-pre-requisites.sh << EOF
#!/bin/bash

STACK_NAME='BatchWorkshop'

# create the stack
echo "1/3 - Create Stack \$STACK_NAME"
aws cloudformation create-stack --stack-name \$STACK_NAME --template-body file://s3policy.yaml --capabilities "CAPABILITY_IAM"

echo "2/3 - Stack \$STACK_NAME being created"
# wait for the stack to be completed
aws cloudformation wait stack-create-complete --stack-name \$STACK_NAME

echo "3/3 - Stack \$STACK_NAME created"
# once done get the role and bucket
export EXECUTION_ROLE=\$(aws cloudformation describe-stacks --stack-name \$STACK_NAME --output text --query 'Stacks[0].Outputs[?OutputKey == \`JobExecutionRole\`].OutputValue')
export STRESS_BUCKET="s3://\$(aws cloudformation describe-stacks --stack-name \$STACK_NAME --output text --query 'Stacks[0].Outputs[?OutputKey == \`Bucket\`].OutputValue')"

echo "Use the following Job Execution Role ID with AWS Batch: \${EXECUTION_ROLE}"
echo "Use the following S3 Bucket for your AWS Batch jobs: \${STRESS_BUCKET}"
EOF
chmod +x cfn-pre-requisites.sh
```
This creates a shell script named **cfn-pre-requisites.sh** which works in conjunction with the **s3policy.yaml** CloudFormation template defined above.

5. Double click the newly created **cfn-pre-requisites.sh** shell script in the Cloud9 file browser to open it in an editor and inspect its contents. Note that there are three basic actions being performed by the script/CloudFormation template:
- Creation of an S3 bucket to store batch job input and output.
- Definition of an IAM Role for batch job execution.
- Attaching a Policy to the IAM Role with the necessary permissions to read and write the S3 bucket.
6. Execute the **cfn-pre-requisites.sh** shell script.
```bash
./cfn-pre-requisites.sh
```
It will take a minute or so for CloudFormation to provision your infrastructure. You can observe progress by inspecting the **BatchWorkshop** stack in [**AWS CloudFormation**](https://console.aws.amazon.com/cloudformation/). The script waits until the infrastructure is ready, and then outputs the **Job Execution Role ID** that will be used for Batch job execution and the **S3 bucket name** used to store input and output. 


### Build a new container for the Leader job


1. Create a new subdirectory called **leader** in which you will build a new container for our Leader job.
```bash
mkdir ~/environment/dependency/leader
cd ~/environment/dependency/leader
```

2. Create a new file named **Dockerfile** in the **leader** directory. 
3. Copy and paste the following into **Dockerfile** and save the file.
```bash
FROM public.ecr.aws/amazonlinux/amazonlinux:latest
RUN yum -y update
RUN amazon-linux-extras install epel -y
RUN yum -y install stress-ng

### Install AWS CLI version 2.
RUN yum -y install unzip
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install -i /usr/local/aws-cli -b /usr/bin
RUN aws --version
RUN rm awscliv2.zip

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
cat /mktests.sh \n\
/mktests.sh \n\
cat /stress-tests.txt \n\
aws s3 ls ${STRESS_BUCKET}/ \n\
aws s3 cp /mktests.sh ${STRESS_BUCKET}/ --quiet \n\
aws s3 cp /stress-tests.txt ${STRESS_BUCKET}/ --quiet \n\
' >> /docker-entrypoint.sh 
RUN chmod 0744 /docker-entrypoint.sh
RUN cat /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
```

Note the changes from the array Dockerfile:
- The AWS CLI is installed within the container to allow it to interact with Amazon S3.
- This job will generate and run the mktests.sh script and copy this script and its output (stress-tests.txt) to the S3 bucket provided to the container via the environment variable ${STRESS_BUCKET}. This will be used by a subsequent Follower array job with each task executing a different command by selecting the corresponding line from /stress-tests.txt depending on their array index variable and setting their STRESS_ARGS environment variable accordingly.
  

3. Create a new repository for the new leader container in Amazon ECR. 

```bash
~/environment/bin/create_repo.sh stress-ng-leader
```

4. Build and push an image of the new leader container.

```bash
~/environment/bin/build_container.sh stress-ng-leader
```


### Leader job definition

Execute the following commands to create a job definition for the Leader job. Note how the job definition below retrieves the **Job Execution Role** and **S3 bucket** from the BatchWorkshop Cloudformation stack.

```bash
export STACK_NAME=BatchWorkshop
export EXECUTION_ROLE="$(aws cloudformation describe-stacks --stack-name $STACK_NAME --output text --query 'Stacks[0].Outputs[?OutputKey == `JobExecutionRole`].OutputValue')"
export EXECUTION_ROLE_ARN=$(aws iam get-role --role-name $EXECUTION_ROLE | jq -r '.Role.Arn')
export LEADER_REPO=$(aws ecr describe-repositories --repository-names stress-ng-leader --output text --query 'repositories[0].[repositoryUri]')
cat > stress-ng-leader-job-definition.json << EOF
{
    "jobDefinitionName": "stress-ng-leader-job-definition",
    "type": "container",
    "containerProperties": {
        "image": "${LEADER_REPO}",
        "vcpus": 1,
        "memory": 1024,
        "jobRoleArn": "${EXECUTION_ROLE_ARN}",
        "executionRoleArn": "${EXECUTION_ROLE_ARN}"
    },
    "retryStrategy": { 
        "attempts": 2
    }
}
EOF
aws batch register-job-definition --cli-input-json file://stress-ng-leader-job-definition.json
```

### Leader job options

Execute the following commands to create a JSON file of job options for the Leader job and execute a test job using this option file.

```bash
export STACK_NAME=BatchWorkshop
export STRESS_BUCKET="s3://$(aws cloudformation describe-stacks --stack-name $STACK_NAME --output text --query 'Stacks[0].Outputs[?OutputKey == `Bucket`].OutputValue')"
cat <<EOF > ./stress-ng-leader-job.json
{
    "jobName": "stress-ng-leader",
    "jobQueue": "stress-ng-queue",
    "jobDefinition": "stress-ng-leader-job-definition",
    "containerOverrides": {
        "environment": [
        {
            "name": "STRESS_BUCKET",
            "value": "${STRESS_BUCKET}"
        }]
    }
}
EOF
aws batch submit-job --cli-input-json file://stress-ng-leader-job.json
```

Track the progress of the job in the [**AWS Batch dashboard**](https://console.aws.amazon.com/batch/). Upon successful completion, your [**Amazon S3**](https://console.aws.amazon.com/s3/) bucket should contain the stress-tests.txt file (along with the mktests.sh script that was used to create it). This file will be used as the input to the Follower job array you will create next. 



### Build a new container for the Follower job

Once you have your Leader job working successfully, you can follow a similar process to set up a new container for the Follower job.


1. Create a new subdirectory called **follower** in which you will build the new container for our Follower job.
```bash
mkdir ~/environment/dependency/follower
cd ~/environment/dependency/follower
```

2. Copy and paste the following into a new file named **Dockerfile** in the **follower** directory.

```bash
FROM public.ecr.aws/amazonlinux/amazonlinux:latest
RUN yum -y update
RUN amazon-linux-extras install epel -y
RUN yum -y install stress-ng

### Install AWS CLI version 2.
RUN yum -y install unzip
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install -i /usr/local/aws-cli -b /usr/bin
RUN aws --version
RUN rm awscliv2.zip

RUN echo $'#!/bin/bash\n\
aws s3 ls ${STRESS_BUCKET}/ \n\
aws s3 cp ${STRESS_BUCKET}/stress-tests.txt / --quiet \n\
STRESS_ARGS=`sed -n $((AWS_BATCH_JOB_ARRAY_INDEX + 1))p /stress-tests.txt` \n\
echo "Passing the following arguments to stress-ng: $STRESS_ARGS" \n\
/usr/bin/stress-ng ${STRESS_ARGS} 2>&1 | aws s3 cp --quiet - ${STRESS_BUCKET}/${AWS_BATCH_JOB_ID}_${AWS_BATCH_JOB_ATTEMPT}_${AWS_BATCH_JOB_ARRAY_INDEX}.txt \n\ 
' >> /docker-entrypoint.sh 
RUN chmod 0744 /docker-entrypoint.sh
RUN cat /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
```

3. Save the **Dockerfile**.
4. Create a **stress-ng-follower** repository.

```bash
 ~/environment/bin/create_repo.sh stress-ng-follower
```

4. Build the **stress-ng-follower** container.

```bash
~/environment/bin/build_container.sh stress-ng-follower
```




### Follower job definition

Execute the following commands to create a job definition for the Follower job. Note how the job definition retrieves the **Job Execution Role** and **S3 bucket** from the BatchWorkshop Cloudformation stack.

```bash
export STACK_NAME=BatchWorkshop
export EXECUTION_ROLE="$(aws cloudformation describe-stacks --stack-name $STACK_NAME --output text --query 'Stacks[0].Outputs[?OutputKey == `JobExecutionRole`].OutputValue')"
export EXECUTION_ROLE_ARN=$(aws iam get-role --role-name $EXECUTION_ROLE | jq -r '.Role.Arn')
export FOLLOWER_REPO=$(aws ecr describe-repositories --repository-names stress-ng-follower --output text --query 'repositories[0].[repositoryUri]')
cat > stress-ng-follower-job-definition.json << EOF
{
    "jobDefinitionName": "stress-ng-follower-job-definition",
    "type": "container",
    "containerProperties": {
        "image": "${FOLLOWER_REPO}",
        "vcpus": 1,
        "memory": 1024,
        "jobRoleArn": "${EXECUTION_ROLE_ARN}",
        "executionRoleArn": "${EXECUTION_ROLE_ARN}"
    },
    "retryStrategy": { 
        "attempts": 2
    }
}
EOF
aws batch register-job-definition --cli-input-json file://stress-ng-follower-job-definition.json
```


### Follower job options

Execute the following commands to create a JSON file of job options for the Follower job and execute a test job using this option file.

```bash
export STACK_NAME=BatchWorkshop
export STRESS_BUCKET="s3://$(aws cloudformation describe-stacks --stack-name $STACK_NAME --output text --query 'Stacks[0].Outputs[?OutputKey == `Bucket`].OutputValue')"
cat <<EOF > ./stress-ng-follower-job.json
{
    "jobName": "stress-ng-follower",
    "jobQueue": "stress-ng-queue",
    "arrayProperties": {
        "size": 2
    },
    "jobDefinition": "stress-ng-follower-job-definition",
    "containerOverrides": {
        "environment": [
        {
            "name": "STRESS_BUCKET",
            "value": "${STRESS_BUCKET}"
        }]
    }
}
EOF
aws batch submit-job --cli-input-json file://stress-ng-follower-job.json --array-properties size=7
```

Note the parameter in the job definition for **"arraysize"** which is used to set the job array size. It is set to a value of 2 (it needs to be > 1 for any array job) but you can also override this value by specifying this parameter on the command line.

At this stage you can run and test the Follower job since you have already successfully executed the Leader job which wrote the required input file. You can track the progress of the Follower job in the [**AWS Batch dashboard**](https://console.aws.amazon.com/batch/). Upon successful completion, your [**Amazon S3**](https://console.aws.amazon.com/s3/) bucket should contain the output files for each member task in the array job. 


### Submit Leader and Follower jobs with a dependency

1. Empty your S3 bucket by executing the following commands.
   
```bash
export STRESS_BUCKET="s3://$(aws cloudformation describe-stacks --stack-name $STACK_NAME --output text --query 'Stacks[0].Outputs[?OutputKey == `Bucket`].OutputValue')"
aws s3 rm ${STRESS_BUCKET} --recursive
```
2. Execute the following commands to submit a Leader job and a Follower array job with a dependency on the successful completion of the Leader.

```bash
### Submit the Leader job and determine its jobID.
cd ~/environment/dependency
export LEADER_JOB=$(aws batch submit-job --cli-input-json file://leader/stress-ng-leader-job.json)
echo "${LEADER_JOB}"
export LEADER_JOB_ID=$(echo ${LEADER_JOB} | jq -r '.jobId')
echo "${LEADER_JOB_ID}"
### Submit the Follower array job with a dependency on the Leader jobID.
export FOLLOWER_JOB=$(aws batch submit-job --cli-input-json file://follower/stress-ng-follower-job.json --depends-on jobId="${LEADER_JOB_ID}",type="N_TO_N" --array-properties size=12)
export FOLLOWER_JOB_ID=$(echo ${FOLLOWER_JOB} | jq -r '.jobId')
echo "${FOLLOWER_JOB_ID}"
```

1. Check the description of the Follower job by executing the following command.

```bash
aws batch describe-jobs --jobs ${FOLLOWER_JOB_ID}
```

You will see the dependency on the Leader job in the returned job description. You can also view this dependency by navigating to a member task of the Follower job in the [**AWS Batch dashboard**](https://console.aws.amazon.com/batch/).

Your Leader job should complete successfully followed by the Follower job array and eventually the output from the 12 tasks of the job array will appear in the S3 bucket.

The AWS Batch User Guide provides more information and examples of array jobs and job dependencies.
https://docs.aws.amazon.com/batch/latest/userguide/example_array_job.html


