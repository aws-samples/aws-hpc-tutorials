#!/bin/bash
# This script sets up the Lab for the Hybrid workshop
# It is designed to run on a Cloud9 instance with Admin rights.
# This script will take about 40-50 minutes to run.
# Always run with logging created. That way debug is much easier if needed.
# For example
# ./workshop.sh | tee workshop-setup.log

# Install Pre-reqs
sudo yum install jq -y

# Generate some random numbers between 0-2, used for selecting AZ/subnets
export INDEX1=`echo $((RANDOM % 2 + 0))`
export INDEX2=$(($INDEX1 + 1))
if [ $INDEX2 = 3 ]
then
  export INDEX2=0
fi
 

# Basic setup to define regions and networks
export AWS_REGION=eu-west-1
export VPC_ID=$(aws ec2 describe-vpcs --filters Name=isDefault,Values=true --query "Vpcs[].VpcId" --region ${AWS_REGION} | jq -r '.[0]')
export ONPREM_SUBNET_ID=$(aws ec2 describe-subnets --region=${AWS_REGION} --filters "Name=vpc-id,Values=$VPC_ID" --query 'Subnets[*].SubnetId' | jq -r --arg i $INDEX1 '.[$i|tonumber]')
export CLOUD_SUBNET_ID=$(aws ec2 describe-subnets --region=${AWS_REGION} --filters "Name=vpc-id,Values=$VPC_ID" --query 'Subnets[*].SubnetId' | jq -r --arg i $INDEX2 '.[$i|tonumber]')

echo Using the following settings:
echo AWS_REGION: $AWS_REGION
echo VPC_ID: $VPC_ID
echo ONPREM_SUBNET_ID: $ONPREM_SUBNET_ID
echo CLOUD_SUBNET_ID: $CLOUD_SUBNET_ID
echo Starting at: `date`

# Create DBInstance and SG
export DBPASSWORD=`uuidgen --random | cut -d '-' -f5`
echo DBPASSWORD: $DBPASSWORD

cat << EOF >> database.yaml
AWSTemplateFormatVersion: 2010-09-09
Description: >-
  This template creates a DB cluster, small changes from the Slurm Parallel Cluster tutorial.
Metadata:
  AWS::CloudFormation::Interface:
    ParameterGroups:
      - Label:
          default: "Database Cluster Configuration"
        Parameters:
          - ClusterName
          - ClusterAdmin
          - AdminPasswordSecretString
          - MinCapacity
          - MaxCapacity
      - Label:
          default: "Network Configuration"
        Parameters:
          - Vpc
          - DatabaseClusterSubnetOne
          - DatabaseClusterSubnetTwo
          - Subnet1CidrBlock
          - Subnet2CidrBlock
    ParameterLabels:
      Vpc:
        default: "The VPC to use for the database cluster."
      ClusterName:
        default: "The name of the database cluster"
      ClusterAdmin:
        default: "The database administrator user name."
      AdminPasswordSecretString:
        default: "The administrator password."
      MinCapacity:
        default: "The minimum scaling capacity of the database cluster."
      MaxCapacity:
        default: "The maximum scaling capacity of the database cluster."
      DatabaseClusterSubnetOne:
        default: "The first subnet to use for the database cluster."
      DatabaseClusterSubnetTwo:
        default: "The second subnet to use for the database cluster."
      Subnet1CidrBlock:
        default: "The CIDR block to be used for the first Subnet if its creation is requested."
      Subnet2CidrBlock:
        default: "The CIDR block to be used for the second Subnet if its creation is requested."
Parameters:
  ClusterName:
    Type: String
    Default: "slurmdb"
    AllowedPattern: ^[a-z][-a-z0-9]{0,62}$
  AdminPasswordSecretString:
    Type: String
    Default: ${DBPASSWORD}
  ClusterAdmin:
    Description: Administrator user name.
    Type: String
    Default: clusteradmin
    MinLength: 3
    MaxLength: 64
  Vpc:
    Description: VPC ID.
    Type: AWS::EC2::VPC::Id
    Default: ${VPC_ID}
  DatabaseClusterSubnetOne:
    Description: First Subnet ID (leave BLANK to create a new subnet).
    Type: String
    # Type: AWS::EC2::Subnet::Id
    Default: ${ONPREM_SUBNET_ID}
  DatabaseClusterSubnetTwo:
    Description: Second subnet ID (leave BLANK to create a new subnet). This subnet must be in different availability zone from the first subnet.
    Type: String
    # Type: AWS::EC2::Subnet::Id
    Default: ${CLOUD_SUBNET_ID}
  Subnet1CidrBlock:
    Description: CIDR block for first Subnet (used only if creation is requested - IN THIS CASE THE DEFAULT VALUE MUST BE CHANGED).
    Type: String
    Default: '0.0.0.0/24'
    AllowedPattern: >-
      ^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(\/(1[6-9]|2[0-8]))$
    ConstraintDescription: >-
      The CIDR block must be formatted as W.X.Y.Z/prefix , where prefix must be between 16 and 28.
  Subnet2CidrBlock:
    Description: CIDR block for the second Subnet (used only if creation is requested - IN THIS CASE THE DEFAULT VALUE MUST BE CHANGED).
    Type: String
    Default: '0.0.0.0/24'
    AllowedPattern: >-
      ^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(\/(1[6-9]|2[0-8]))$
    ConstraintDescription: >-
      The CIDR block must be formatted as W.X.Y.Z/prefix , where prefix must be between 16 and 28.
  MinCapacity:
    Description: Must be less than the maximum capacity.
    Type: Number
    Default: 1
    MinValue: .5
    MaxValue: 127.5
  MaxCapacity:
    Description: Must be greater than or equal to the minimum capacity.
    Type: Number
    Default: 4
    MinValue: 1
    MaxValue: 128
Transform: AWS::Serverless-2016-10-31
Conditions:
  CreateSubnets: !Or [!Equals [!Ref DatabaseClusterSubnetOne, ''], !Equals [!Ref DatabaseClusterSubnetTwo, '']]
Rules:
  BadSubnetsCidrsAssertion:
    RuleCondition: !Or
      - !Equals
        - !Ref DatabaseClusterSubnetOne
        - ''
      - !Equals
        - !Ref DatabaseClusterSubnetTwo
        - ''
    Assertions:
      - Assert: !Not
          - !Equals
            - !Ref Subnet1CidrBlock
            - '0.0.0.0/24'
        AssertDescription: The default CIDR block for the first subnet must be changed if the subnet creation is requested.
      - Assert: !Not
          - !Equals
            - !Ref Subnet2CidrBlock
            - '0.0.0.0/24'
        AssertDescription: The default CIDR block for the second subnet must be changed if the subnet creation is requested.
Resources:
  #
  # Optional Networking
  #
  AccountingClusterSubnet1:
    Type: 'AWS::EC2::Subnet'
    Condition: CreateSubnets
    Properties:
      VpcId: !Ref Vpc
      AvailabilityZone: !Sub '${AWS::Region}a'
      CidrBlock: !Ref Subnet1CidrBlock
      MapPublicIpOnLaunch: false
      Tags:
        - Key: Name
          Value: AccountingClusterSubnet1
        - Key: 'parallelcluster:infrastructure'
          Value: 'slurm accounting'
  AccountingClusterSubnet1RouteTable:
    Type: 'AWS::EC2::RouteTable'
    Condition: CreateSubnets
    Properties:
      VpcId: !Ref Vpc
      Tags:
        - Key: Name
          Value: AccountingClusterSubnet1
        - Key: 'parallelcluster:infrastructure'
          Value: 'slurm accounting'
  AccountingClusterSubnet1RouteTableAssociation:
    Type: 'AWS::EC2::SubnetRouteTableAssociation'
    Condition: CreateSubnets
    Properties:
      RouteTableId: !Ref AccountingClusterSubnet1RouteTable
      SubnetId: !Ref AccountingClusterSubnet1
  AccountingClusterSubnet2:
    Type: 'AWS::EC2::Subnet'
    Condition: CreateSubnets
    Properties:
      VpcId: !Ref Vpc
      AvailabilityZone: !Sub '${AWS::Region}b'
      CidrBlock:  !Ref Subnet2CidrBlock
      MapPublicIpOnLaunch: false
      Tags:
        - Key: Name
          Value: AccountingClusterSubnet2
        - Key: 'parallelcluster:infrastructure'
          Value: 'slurm accounting'
  AccountingClusterSubnet2RouteTable:
    Type: 'AWS::EC2::RouteTable'
    Condition: CreateSubnets
    Properties:
      VpcId: !Ref Vpc
      Tags:
        - Key: Name
          Value: AccountingClusterSubnet2
        - Key: 'parallelcluster:infrastructure'
          Value: 'slurm accounting'
  AccountingClusterSubnet2RouteTableAssociation:
    Type: 'AWS::EC2::SubnetRouteTableAssociation'
    Condition: CreateSubnets
    Properties:
      RouteTableId: !Ref AccountingClusterSubnet2RouteTable
      SubnetId: !Ref AccountingClusterSubnet2

  #
  # Database Cluster
  #
  AccountingClusterParameterGroup:
    Type: 'AWS::RDS::DBClusterParameterGroup'
    Properties:
      Description: Cluster parameter group for aurora-mysql
#      Family: aurora-mysql5.7
      Family: aurora-mysql8.0
      Parameters:
        require_secure_transport: 'ON'
        innodb_lock_wait_timeout: '900'
      Tags:
        - Key: 'parallelcluster:usecase'
          Value: 'slurm accounting'
  AccountingClusterSubnetGroup:
    Type: 'AWS::RDS::DBSubnetGroup'
    Properties:
      DBSubnetGroupDescription: !Sub 'Subnets for AccountingCluster-${AWS::Region} database'
      SubnetIds:
        - !If [CreateSubnets, !Ref AccountingClusterSubnet1, !Ref DatabaseClusterSubnetOne]
        - !If [CreateSubnets, !Ref AccountingClusterSubnet2, !Ref DatabaseClusterSubnetTwo]
      Tags:
        - Key: 'parallelcluster:usecase'
          Value: 'slurm accounting'
  AccountingClusterSecurityGroup:
    Type: 'AWS::EC2::SecurityGroup'
    Properties:
      GroupDescription: RDS security group
      SecurityGroupEgress:
        - CidrIp: 0.0.0.0/0
          Description: Allow all outbound traffic by default
          IpProtocol: '-1'
      Tags:
        - Key: 'parallelcluster:usecase'
          Value: 'slurm accounting'
      VpcId: !Ref Vpc
  AccountingClusterSecurityGroupInboundRule:
    Type: 'AWS::EC2::SecurityGroupIngress'
    Properties:
      IpProtocol: tcp
      Description: Allow incoming connections from client security group
      FromPort: !GetAtt
        - AccountingCluster
        - Endpoint.Port
      GroupId: !GetAtt
        - AccountingClusterSecurityGroup
        - GroupId
      SourceSecurityGroupId: !GetAtt
        - AccountingClusterClientSecurityGroup
        - GroupId
      ToPort: !GetAtt
        - AccountingCluster
        - Endpoint.Port
  AccountingClusterAdminSecret:
    Type: 'AWS::SecretsManager::Secret'
    Properties:
      Description: 'Serverless Database Cluster Administrator Password'
      SecretString: !Ref AdminPasswordSecretString
      Tags:
        - Key: 'parallelcluster:usecase'
          Value: 'slurm accounting'
  AccountingCluster:
    Type: 'AWS::RDS::DBCluster'
    Properties:
      DBClusterIdentifier: !Ref ClusterName
      Engine: "aurora-mysql"
      EngineVersion: "8.0.mysql_aurora.3.02.1"
      CopyTagsToSnapshot: true
      DBClusterParameterGroupName: !Ref AccountingClusterParameterGroup
      DBSubnetGroupName: !Ref AccountingClusterSubnetGroup
      EnableHttpEndpoint: false
      MasterUsername: !Ref ClusterAdmin
      MasterUserPassword: !Ref AdminPasswordSecretString
      ServerlessV2ScalingConfiguration:
        MaxCapacity: !Ref MaxCapacity
        MinCapacity: !Ref MinCapacity
      StorageEncrypted: true
      Tags:
        - Key: 'parallelcluster:usecase'
          Value: 'slurm accounting'
      VpcSecurityGroupIds:
        - !GetAtt
          - AccountingClusterSecurityGroup
          - GroupId
    UpdateReplacePolicy: Delete
    DeletionPolicy: Delete
  AccountingClusterInstance1:
    Type: 'AWS::RDS::DBInstance'
    Properties:
      DBInstanceClass: 'db.serverless'
      DBClusterIdentifier: !Ref AccountingCluster
      DBInstanceIdentifier: 'slurm-instance-1'
      Engine: "aurora-mysql"
      PubliclyAccessible: false
    UpdateReplacePolicy: Delete
    DeletionPolicy: Delete
  AccountingClusterInstance2:
    Type: 'AWS::RDS::DBInstance'
    Properties:
      DBInstanceClass: 'db.serverless'
      DBClusterIdentifier: !Ref AccountingCluster
      DBInstanceIdentifier: 'slurm-instance-2'
      Engine: "aurora-mysql"
      PubliclyAccessible: false
    UpdateReplacePolicy: Delete
    DeletionPolicy: Delete
  AccountingClusterClientSecurityGroup:
    Type: 'AWS::EC2::SecurityGroup'
    Properties:
      GroupDescription: Security Group to allow connection to Serverless DB Cluster
      Tags:
        - Key: 'parallel-cluster:usecase'
          Value: 'slurm accounting'
      VpcId: !Ref Vpc
  AccountingClusterClientSecurityGroupOutboundRule:
    Type: 'AWS::EC2::SecurityGroupEgress'
    Properties:
      GroupId: !GetAtt
        - AccountingClusterClientSecurityGroup
        - GroupId
      IpProtocol: tcp
      Description: Allow incoming connections from PCluster
      DestinationSecurityGroupId: !GetAtt
        - AccountingClusterSecurityGroup
        - GroupId
      FromPort: !GetAtt
        - AccountingCluster
        - Endpoint.Port
      ToPort: !GetAtt
        - AccountingCluster
        - Endpoint.Port
Outputs:
  ClusterName:
    Value: !Ref ClusterName
  DatabaseHost:
    Value: !GetAtt
      - AccountingCluster
      - Endpoint.Address
  DatabasePort:
    Value: !GetAtt
      - AccountingCluster
      - Endpoint.Port
  DatabaseAdminUser:
    Value: !Ref ClusterAdmin
  DatabaseVpcId:
    Value: !Ref Vpc
  DatabaseClusterSecurityGroup:
    Value: !GetAtt
      - AccountingClusterSecurityGroup
      - GroupId
  DatabaseClusterSubnet1:
    Value: !If [CreateSubnets, !Ref AccountingClusterSubnet1, !Ref DatabaseClusterSubnetOne]
  DatabaseClusterSubnet2:
    Value: !If [CreateSubnets, !Ref AccountingClusterSubnet2, !Ref DatabaseClusterSubnetTwo]
  DatabaseClientSecurityGroup:
    Value: !GetAtt
      - AccountingClusterClientSecurityGroup
      - GroupId
  DatabaseSecretArn:
    Value: !Ref AccountingClusterAdminSecret
EOF
echo Deploying the Database
aws cloudformation deploy --stack-name clusterdb --template-file database.yaml --region=${AWS_REGION}

date

aws cloudformation wait stack-create-complete --stack-name clusterdb

date

# Grab DB Details
export CLUSTERSGID=`aws cloudformation --region ${AWS_REGION} describe-stacks --stack-name clusterdb | jq '.Stacks'[0]'.Outputs' | jq 'map(select(.OutputKey == "DatabaseClientSecurityGroup"))' | grep OutputValue | cut -f 4 -d \"`
export DBINSTANCE=`aws cloudformation --region ${AWS_REGION} describe-stacks --stack-name clusterdb | jq '.Stacks'[0]'.Outputs' | jq 'map(select(.OutputKey == "DatabaseHost"))' | grep OutputValue | cut -f 4 -d \"`
export DBSECRETARN=`aws cloudformation --region ${AWS_REGION} describe-stacks --stack-name clusterdb | jq '.Stacks'[0]'.Outputs' | jq 'map(select(.OutputKey == "DatabaseSecretArn"))' | grep OutputValue | cut -f 4 -d \"`

echo CLUSTERSGID: $CLUSTERSGID
echo DBINSTANCE: $DBINSTANCE
echo DBSECRETARN: $DBSECRETARN

date

# Create a bucket to store scripts
export BUCKET_NAME=pcluster-$(date +%F)-$(uuidgen --random | cut -d'-' -f1)
echo "export BUCKET_NAME=${BUCKET_NAME}" |tee -a ~/.bashrc
aws s3 mb s3://${BUCKET_NAME} --region=${AWS_REGION}

# Create Munge Key and save to secrets manager
uuidgen --random > munge.key
#aws secretsmanager create-secret --name pcmungekey --secret-string `cat munge.key` --region=${AWS_REGION}
aws s3 cp munge.key s3://${BUCKET_NAME}/

# Install Pcluster
sudo yum install python3-pip
python3 -m pip install "aws-parallelcluster==3.5.1" --upgrade --user
#curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
#chmod ug+x ~/.nvm/nvm.sh
#node --version
#nvm install --lts
#source ~/.nvm/nvm.sh


# Create cluster post install scripts and copy to S3
cat << EOF >> onprem-headnode.sh
#!/bin/bash
#aws secretsmanager get-secret-value --secret-id pcmungekey --region=${AWS_REGION} | jq '.SecretString' | sed s/\"//g > /etc/munge/munge.key
aws s3 cp s3://${BUCKET_NAME}/munge.key /etc/munge/munge.key
chown munge.munge /etc/munge/munge.key
chmod 600 /etc/munge/munge.key
systemctl restart munge
systemctl restart slurmctld
systemctl restart slurmdbd
EOF

cat << EOF >> onprem-compute.sh
#!/bin/bash
#aws secretsmanager get-secret-value --secret-id pcmungekey --region=${AWS_REGION} | jq '.SecretString' | sed s/\"//g > /etc/munge/munge.key
aws s3 cp s3://${BUCKET_NAME}/munge.key /etc/munge/munge.key
chown munge.munge /etc/munge/munge.key
chmod 600 /etc/munge/munge.key
systemctl restart munge
systemctl restart slurmd
EOF

cat << EOF >> cloud-headnode.sh
#!/bin/bash
#aws secretsmanager get-secret-value --secret-id pcmungekey --region=${AWS_REGION} | jq '.SecretString' | sed s/\"//g > /etc/munge/munge.key
aws s3 cp s3://${BUCKET_NAME}/munge.key /etc/munge/munge.key
chown munge.munge /etc/munge/munge.key
chmod 600 /etc/munge/munge.key
systemctl restart munge
systemctl restart slurmctld
systemctl restart slurmdbd
EOF

cat << EOF >> cloud-compute.sh
#!/bin/bash
#aws secretsmanager get-secret-value --secret-id pcmungekey --region=${AWS_REGION} | jq '.SecretString' | sed s/\"//g > /etc/munge/munge.key
aws s3 cp s3://${BUCKET_NAME}/munge.key /etc/munge/munge.key
chown munge.munge /etc/munge/munge.key
chmod 600 /etc/munge/munge.key
systemctl restart munge
systemctl restart slurmd
EOF

# Make scripts executable and copy up to S3
for i in onprem-headnode.sh onprem-compute.sh cloud-headnode.sh cloud-compute.sh
do
  chmod 755 $i
  aws s3 cp $i s3://${BUCKET_NAME}/
done

# Create ssh key and copy to bucket
export SSH_KEY=key-$(date +%F)-$(uuidgen --random | cut -d'-' -f1)
aws ec2 create-key-pair --key-name $SSH_KEY --query KeyMaterial --output text > ssh-key.pem
aws s3 cp ssh-key.pem s3://${BUCKET_NAME}/
#aws secretsmanager create-secret --name ssh-key --secret-string `cat ssh-key.pem` --region=${AWS_REGION}

# Build cluster configs
cat << EOF >> onprem.yaml
---
Image:
  Os: alinux2
Region: ${AWS_REGION}
Scheduling:
  Scheduler: slurm
  SlurmQueues:
  - Name: onpremq
    ComputeResources:
      - Name: c6i
        InstanceType: c6i.large
        MaxCount: 1
        MinCount: 1
        Efa:
          Enabled: false
    Iam:
      AdditionalIamPolicies:
        - Policy: arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore
        - Policy: arn:aws:iam::aws:policy/AmazonSSMPatchAssociation
      S3Access:
        - BucketName: ${BUCKET_NAME}
    Networking:
      SubnetIds:
        - ${ONPREM_SUBNET_ID}
      AdditionalSecurityGroups:
        - ${CLUSTERSGID}
    ComputeSettings:
      LocalStorage:
        RootVolume:
          Size: 35   
    CustomActions:
      OnNodeConfigured:
        Script: s3://${BUCKET_NAME}/onprem-compute.sh
        Args:
          - param1
          - param2
          - param3
  SlurmSettings:
    Dns:
      DisableManagedDns: false
    ScaledownIdletime: 2
    Database:
      Uri: ${DBINSTANCE}
      UserName: clusteradmin
      PasswordSecretArn: ${DBSECRETARN}
HeadNode:
  Iam:
    AdditionalIamPolicies:
      - Policy: arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore
      - Policy: arn:aws:iam::aws:policy/AmazonSSMPatchAssociation
      - Policy: arn:aws:iam::aws:policy/SecretsManagerReadWrite
    S3Access:
      - BucketName: ${BUCKET_NAME}
  Imds:
    Secured: true
  InstanceType: c6i.xlarge
  LocalStorage:
    EphemeralVolume:
      MountDir: "/local/ephemeral"
    RootVolume:
      Size: 50
  Networking:
    SubnetId: ${ONPREM_SUBNET_ID}
    AdditionalSecurityGroups:
      - ${CLUSTERSGID}
  Ssh:
    KeyName: ${SSH_KEY}
  CustomActions:
    OnNodeConfigured:
      Script: s3://${BUCKET_NAME}/onprem-headnode.sh
      Args:
        - param1
        - param2
        - param3
SharedStorage:
  - MountDir: /data
    Name: data
    StorageType: Ebs
    EbsSettings:
      VolumeType: gp3
      Size: 100
EOF
sleep 1
pcluster create-cluster -n onprem -c onprem.yaml -r ${AWS_REGION} --suppress-validators type:PasswordSecretArnValidator


cat << EOF > cloud.yaml
---
Image:
  Os: alinux2
Region: ${AWS_REGION}
Scheduling:
  Scheduler: slurm
  SlurmQueues:
  - Name: cloudq
    ComputeResources:
      - Name: c6i
        InstanceType: c6i.large
        MaxCount: 10
        MinCount: 0
        Efa:
          Enabled: false
    Iam:
      AdditionalIamPolicies:
        - Policy: arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore
        - Policy: arn:aws:iam::aws:policy/AmazonSSMPatchAssociation
      S3Access:
        - BucketName: ${BUCKET_NAME}
    Networking:
      SubnetIds:
        - ${CLOUD_SUBNET_ID}
      AdditionalSecurityGroups:
        - ${CLUSTERSGID}
    ComputeSettings:
      LocalStorage:
        RootVolume:
          Size: 35  
    CustomActions:
      OnNodeConfigured:
        Script: s3://${BUCKET_NAME}/cloud-compute.sh
        Args:
          - param1
          - param2
          - param3
  SlurmSettings:
    Dns:
      DisableManagedDns: false
    ScaledownIdletime: 2
    Database:
      Uri: ${DBINSTANCE}
      UserName: clusteradmin
      PasswordSecretArn: ${DBSECRETARN}
HeadNode:
  Iam:
    AdditionalIamPolicies:
      - Policy: arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore
      - Policy: arn:aws:iam::aws:policy/AmazonSSMPatchAssociation
      - Policy: arn:aws:iam::aws:policy/SecretsManagerReadWrite
    S3Access:
      - BucketName: ${BUCKET_NAME}
  Imds:
    Secured: true
  InstanceType: c6i.xlarge
  LocalStorage:
    EphemeralVolume:
      MountDir: "/local/ephemeral"
    RootVolume:
      Size: 50
  Networking:
    SubnetId: ${CLOUD_SUBNET_ID}
    AdditionalSecurityGroups:
      - ${CLUSTERSGID}
  Ssh:
    KeyName: ${SSH_KEY}
  CustomActions:
    OnNodeConfigured:
      Script: s3://${BUCKET_NAME}/cloud-headnode.sh
      Args:
        - param1
        - param2
        - param3
EOF
sleep 1
pcluster create-cluster -n cloud -c cloud.yaml -r ${AWS_REGION} --suppress-validators type:PasswordSecretArnValidator

# Copy Cluster configs up to S3
for i in onprem.yaml cloud.yaml
do
  chmod 755 $i
  aws s3 cp $i s3://${BUCKET_NAME}/
done

echo XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
echo ""
echo Setup Complete.
echo ""

