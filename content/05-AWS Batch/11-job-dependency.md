+++
title = "k. Job Dependencies"
date = 2019-09-18T10:46:30-04:00
weight = 110
tags = ["tutorial", "install", "AWS", "batch", "Docker"]
+++

In this step you will implement a more realistic workflow scenario that employs multiple jobs, shared data, and implements job dependencies as an example of a common Master/Worker pattern.

You will essentially split the work of from the previous array example into two separate jobs:
- A **Master** job will define the work to be carried out and write this configuration to a specified S3 bucket. This is effectively accomplished by executing the previous mktests.sh script and uploading the resulting stress-tests.txt file to the specified S3 bucket.
- Each member task of a **Worker** array job will then read the stress-tests.txt file from the S3 bucket to determine which test to carry out based on its array index in a simlar manner to your previous array job. Each Worker task will now write their output to a file in the specified S3 bucket.

You will implement a job dependency such that the Master job runs first and the Worker array job will only start on successful completion of the Master job.


### Create an S3 Bucket and IAM Role 

You will use a shell script and CloudFormation template to automate the creation of an S3 bucket and a specific IAM Role with limited read and write permissions to that bucket. 


1. Copy and paste the following CloudFormation template into a file named s3policy.yaml

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

2. Copy and paste the following command to your terminal session on your Cloud9 instance.
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
3. Execute the cfn-pre-requisites.sh shell script.
```bash
./cfn-pre-requisites.sh
```

There are three basic steps being performed:
- Create an S3 bucket to store batch job input and output.
- Define an IAM Role with the necessary permissions for batch job execution.
- Attach an additional Policy to the Role that allowing it to read and write the S3 bucket.

It takes a minute or so for CloudFormation to provision your infrastructure. You can observe progress and see the details by inspecting the **BatchWorkshop** stack in [**AWS CloudFormation**](https://console.aws.amazon.com/cloudformation/).

The script waits until the base infrastructure is ready, and then outputs the **Job Execution Role ID** that will be used for Batch job execution and the **S3 bucket name** used to store input and output. 



### Build a new container for the Master Job


1. Create a new subdirectory called master in which we will build a new container for our master job.
```bash
mkdir ~/master
cd ~/master
```

2. Copy and paste the following into a new file named Dockerfile in the master directory.
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
- This job will generate and run the /mktests.sh script and copy the ouptput file (/stress-tests.txt) to an S3 bucket provided by the environment variable ${STRESS_BUCKET}. This will be used by a subsequent worker array job with each task executing a different command by selecting the corresponding line from /stress-tests.txt depending on their array index variable and setting their STRESS_ARGS environment variable accordingly.
  


3. Create a new repository for our new master container in Amazon ECR. 

```bash
~/bin/create_repo.sh stress-ng-master
```

4. Build and push an image of your new master container.

```bash
~/bin/build_container.sh stress-ng-master
```


### Master job definition

Create a new job definition for the new Master job. Note how the job definition below uses the **Job Execution Role** and **S3 bucket** instantiated by the BatchWorkshop Cloudformation stack.

```bash
export STACK_NAME=BatchWorkshop
export EXECUTION_ROLE="$(aws cloudformation describe-stacks --stack-name $STACK_NAME --output text --query 'Stacks[0].Outputs[?OutputKey == `JobExecutionRole`].OutputValue')"
export EXECUTION_ROLE_ARN=$(aws iam get-role --role-name $EXECUTION_ROLE | jq -r '.Role.Arn')
export MASTER_REPO=$(aws ecr describe-repositories --repository-names stress-ng-master --output text --query 'repositories[0].[repositoryUri]')
cat > stress-ng-master-job-definition.json << EOF
{
    "jobDefinitionName": "stress-ng-master-job-definition",
    "type": "container",
    "containerProperties": {
        "image": "${MASTER_REPO}",
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
aws batch register-job-definition --cli-input-json file://stress-ng-master-job-definition.json
```

### Master job options

Execute the following to create a JSON file of job options for the Master job and execute a test job using this option file.

```bash
export STACK_NAME=BatchWorkshop
export STRESS_BUCKET="s3://$(aws cloudformation describe-stacks --stack-name $STACK_NAME --output text --query 'Stacks[0].Outputs[?OutputKey == `Bucket`].OutputValue')"
cat <<EOF > ./stress-ng-master-job.json
{
    "jobName": "stress-ng-master",
    "jobQueue": "stress-ng-queue",
    "jobDefinition": "stress-ng-master-job-definition",
    "containerOverrides": {
        "environment": [
        {
            "name": "STRESS_BUCKET",
            "value": "${STRESS_BUCKET}"
        }]
    }
}
EOF
aws batch submit-job --cli-input-json file://stress-ng-master-job.json
```

Track the progress of the job in the [**AWS Batch dashboard**](https://console.aws.amazon.com/batch/). Upon successful completion, your [**Amazon S3**](https://console.aws.amazon.com/s3/) bucket should contain the stress-tests.txt file (along with the mktests.sh script that was used to create it). This will be used as the input to the worker job array we will create next. 



### Build a new container for the Worker Job

Once you have your Master job working successfully, you can follow a similar process to set up a new Worker container which will run as an array job.


1. Create a new subdirectory called worker in which we will build a new container for our worker job.
```bash
mkdir ~/worker
cd ~/worker
```

2. Copy and paste the following into a new file named Dockerfile in the worker directory.

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

3. Create a stress-ng-worker repository.

```bash
 ~/bin/create_repo.sh stress-ng-worker
```

4. Build the container.

```bash
~/bin/build_container.sh stress-ng-worker
```




### Worker job definition

Execute the following to create a job definition for the new Worker job. Note how the job definition uses the **Job Execution Role** and **S3 bucket** instantiated by the BatchWorkshop Cloudformation stack.

```bash
export STACK_NAME=BatchWorkshop
export EXECUTION_ROLE="$(aws cloudformation describe-stacks --stack-name $STACK_NAME --output text --query 'Stacks[0].Outputs[?OutputKey == `JobExecutionRole`].OutputValue')"
export EXECUTION_ROLE_ARN=$(aws iam get-role --role-name $EXECUTION_ROLE | jq -r '.Role.Arn')
export WORKER_REPO=$(aws ecr describe-repositories --repository-names stress-ng-worker --output text --query 'repositories[0].[repositoryUri]')
cat > stress-ng-worker-job-definition.json << EOF
{
    "jobDefinitionName": "stress-ng-worker-job-definition",
    "type": "container",
    "containerProperties": {
        "image": "${WORKER_REPO}",
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
aws batch register-job-definition --cli-input-json file://stress-ng-worker-job-definition.json
```



### Worker job options

Execute the following to create a JSON file of job options for the Worker job and execute a test job using this option file.

```bash
export STACK_NAME=BatchWorkshop
export STRESS_BUCKET="s3://$(aws cloudformation describe-stacks --stack-name $STACK_NAME --output text --query 'Stacks[0].Outputs[?OutputKey == `Bucket`].OutputValue')"
cat <<EOF > ./stress-ng-worker-job.json
{
    "jobName": "stress-ng-worker",
    "jobQueue": "stress-ng-queue",
    "arrayProperties": {
        "size": 2
    },
    "jobDefinition": "stress-ng-worker-job-definition",
    "containerOverrides": {
        "environment": [
        {
            "name": "STRESS_BUCKET",
            "value": "${STRESS_BUCKET}"
        }]
    }
}
EOF
aws batch submit-job --cli-input-json file://stress-ng-worker-job.json --array-properties size=7
```

Note the parameter in the job definition for **"arraysize"** which is used to set the job array size. It has a default of 2 (it needs to be > 1 for any array job) but you override this default by specifying a parameter on the command line.

At this stage you can run and test the Worker job since you have already successfully executed the Master job which has written the required input for the Worker job. You can track the progress of the Worker job in the [**AWS Batch dashboard**](https://console.aws.amazon.com/batch/). Upon successful completion, your [**Amazon S3**](https://console.aws.amazon.com/s3/) bucket should contain the output files for each member task in the array. 


### Submit Master and Worker jobs with dependency

1. Empty your S3 bucket by executing the following commands.
   
```bash
export STRESS_BUCKET="s3://$(aws cloudformation describe-stacks --stack-name $STACK_NAME --output text --query 'Stacks[0].Outputs[?OutputKey == `Bucket`].OutputValue')"
aws s3 rm ${STRESS_BUCKET} --recursive
```
2. Execute the following commands to submit a Master job and Worker array job with a dependency on the Master.

```bash
### Submit the Master job and determine its jobID.
cd ~
export MASTER_JOB=$(aws batch submit-job --cli-input-json file://master/stress-ng-master-job.json)
echo "${MASTER_JOB}"
export MASTER_JOB_ID=$(echo ${MASTER_JOB} | jq -r '.jobId')
echo "${MASTER_JOB_ID}"
### Submit the Worker array job with a dependency on the Master jobID.
export WORKER_JOB=$(aws batch submit-job --cli-input-json file://worker/stress-ng-worker-job.json --depends-on jobId="${MASTER_JOB_ID}",type="N_TO_N" --array-properties size=12)
export WORKER_JOB_ID=$(echo ${WORKER_JOB} | jq -r '.jobId')
echo "${WORKER_JOB_ID}"
```

2. Check the description of the Worker job by substituting the jobId from the last line of output above into the following command in place of YOUR-JOB-ID.

```bash
aws batch describe-jobs --jobs ${WORKER_JOB_ID}
```

You will see the dependency on the master job. You can also view this dependency by navigating to a member task of the Worker job in the [**AWS Batch dashboard**](https://console.aws.amazon.com/batch/).

Your Master job should complete successfully and followed by the Worker job array and eventually the output from the 12 tasks of the job array will appear in the S3 bucket.

The AWS Batch User Guide provides more information and examples of array jobs and job dependencies.
https://docs.aws.amazon.com/batch/latest/userguide/example_array_job.html


