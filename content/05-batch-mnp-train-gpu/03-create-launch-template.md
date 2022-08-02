---
title : "d. Create Launch Template with User Data"
date: 2022-07-22T15:58:58Z
weight : 40
tags : ["configuration", "vpc", "subnet", "iam", "pem"]
---

In this step, you create the EC2 launch template with the user data to mount the EFS. The process involves creation of a json configuration that will be used to create the launch template using aws cli. 

### Log into AWS Cloud9
1. Log into your AWS Cloud9 that you created in the previous step
2. Download the tar file [create_launch_template.tar.gz](/scripts/batch_mnp/create_launch_template.tar.gz)
3. Upload the tar.gz file to the Cloud9 using the upload file option

```bash
gunzip create_launch_template.tar.gz
tar xvf create_launch_template.tar
```

### Creating the launch template
The folder "create_launch_template" has a template folder along with python code to easily create a merged json file for creating the launch template using aws cli.

At a high level, the python program will
- start with the base ec2_launch_template is present in ./template/ec2_template_config.json
- override the values/fields by the content of ./overdide_dict.json
- encode the ./template/efs_ecs_launch_template.yml and create an user_data string
- finally, export a ./export_dict.json which is the single json that could be used to create the launch template

Below we explain the placeholders in the template that needs to be modified based on the values of subnet, efs, pem key and iam profiles created from the previous steps

#### Update ./template/efs_ecs_launch_template.yml

The yaml file contains multi-part commands to 
- create the efs mount to /mnt/efs and
- create a /scratch folder

Users can add additional commands that they would like to run during instance startup

```yaml
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="==MYBOUNDARY=="

--==MYBOUNDARY==
Content-Type: text/cloud-config; charset="us-ascii"

packages:
- amazon-efs-utils

runcmd:
- efs_file_system_id_01=<EFS MOUNT DNS>
- efs_directory=/mnt/efs
- mkdir -p ${efs_directory}
- echo "${efs_file_system_id_01}:/ ${efs_directory} efs tls,_netdev" >> /etc/fstab
- mount -a -t efs defaults

- mkdir -p /scratch

--==MYBOUNDARY==--
```

##### Replace Place Holders

| PlaceHolder     	| Replace With                 	|
|-----------------	|------------------------------	|
| EFS MOUNT DNS 	| full dns name of the efs dns (No Quotes) 	|

#### Scan ./template/ec2-template-config.json

The json file has the base ec2 template with 
- Place Holder for the IamInstanceProfile
- Block device with 200GB root volume
- One Network Interface with placeholder for the Security Groups
- Place Holder for User Data
- Place Holder for the Tag Specifications for the instance launched

```json
{
  "DryRun": false,
  "LaunchTemplateName": "",
  "VersionDescription": "Launch template created by aws-do-cli",
  "LaunchTemplateData": {
    "IamInstanceProfile": {
      "Arn": ""
    },
    "BlockDeviceMappings": [
      {
        "DeviceName": "/dev/xvda",
        "Ebs": {
          "VolumeSize": 200,
          "DeleteOnTermination": true
        }
      }
    ],
    "NetworkInterfaces": [
      {
        "AssociatePublicIpAddress": true,
        "DeleteOnTermination": true,
        "DeviceIndex": 0,
        "Groups": [
          ""
        ],
        "Ipv6AddressCount": 0,
        "SubnetId": "",
        "NetworkCardIndex": 0
      }
    ],
    "ImageId": "",
    "KeyName": "",
    "Monitoring": {
      "Enabled": true
    },
    "DisableApiTermination": false,
    "InstanceInitiatedShutdownBehavior": "stop",
    "UserData": "",
    "TagSpecifications": [
      {
        "ResourceType": "instance",
        "Tags": [
          {
            "Key": "purpose",
            "Value": "g5 batch training"
          }
        ]
      }
    ],
    "MetadataOptions": {
      "HttpTokens": "required",
      "HttpPutResponseHopLimit": 5,
      "HttpEndpoint": "enabled"
    }
  },
  "TagSpecifications": [
    {
      "ResourceType": "launch-template",
      "Tags": [
        {
          "Key": "purpose",
          "Value": "batch training"
        }
      ]
    }
  ]
}

```

Typically these values can be left untouched and be overridden from the override_dict.json

#### Update ./override_dict.json
```json
{
  "LaunchTemplateName": "ECS_G_MNP_EFS",
  "VersionDescription": "Override Template",
  "LaunchTemplateData": {
    "IamInstanceProfile": {
      "Arn": "<INSTANCE PROFILE>"
    },
    "NetworkInterfaces": [
      {
        "AssociatePublicIpAddress": false,
        "DeleteOnTermination": true,
        "DeviceIndex": 0,
        "Groups": [
          "<SECURITY GROUP>"
        ],
        "Ipv6AddressCount": 0,
        "SubnetId": "<SUBNET>",
        "NetworkCardIndex": 0
      }
    ],
    "ImageId": "ami-03ac1ceb652b26442",
    "KeyName": "<PEM KEY NAME>",
    "UserData": "",
    "TagSpecifications": [
      {
        "ResourceType": "instance",
        "Tags": [
          {
            "Key": "purpose",
            "Value": "batch multinode training"
          }
        ]
      }
    ]
  }
}
```
**Note: When you are entering strings inside JSON file, it has to be quoted for a valid json**

| PlaceHolder      	| Replace With                                                           	|
|------------------	|------------------------------------------------------------------------	|
| INSTANCE PROFILE 	| `"arn:aws:iam::123456789012:instance-profile/ecsInstanceRole"` 	|
| SECURITY GROUP   	| `"sg-0123456789"`                                              	|
| SUBNET           	| `"subnet-0123456789"`                                         	|
| PEM KEY NAME     	| `"key_name"`                                          	|

#### Run the Python Command

```bash
python3 create_ec2_template.py 
```

This will create an export_dict.json which can be utilized to create the ec2 launch template

```bash
aws ec2 create-launch-template --cli-input-json file://export_dict.json
```

Upon successful execution, it will output the LaunchTemplateId and LaunchTemplateName. 
```json
{
    "LaunchTemplate": {
        "LaunchTemplateId": "lt-0123456789",
        "LaunchTemplateName": "ECS_G_EFS",
        "CreateTime": "2022-06-03T21:41:11+00:00",
        "CreatedBy": "...",
        "DefaultVersionNumber": 1,
        "LatestVersionNumber": 1,
        "Tags": [
            {
                "Key": "purpose",
                "Value": "batch training"
            }
        ]
    }
}
```
This will be needed for creating the compute environment in AWS Batch.

### Additional Verification for Launch Template

We can check if the launch template has been setup correctly by launching instances based of it into the private subnet. Since the instance would not have a public ip to login - we have to create a jump host (bastion) instance in the public subnet and then ssh into the private subnet.

Steps to create the bastion jump host
- Create a very small c5.2xlarge instance in the public subnet of the same VPC using the EC2 console
- This instance will have a public IP which one can ssh into from your personal machine
- Copy your pem file into this instance
- Login to the instances in the private subnet using the pem file and the private ip 

Once you login to the instances launched based on the template, check if the drives have been properly mounted using
```bash
[ec2-user@ip-172-31-89-103 ~]$ df -h
Filesystem      Size  Used Avail Use% Mounted on
devtmpfs        4.0M     0  4.0M   0% /dev
tmpfs            16G     0   16G   0% /dev/shm
tmpfs           6.3G  608K  6.3G   1% /run
/dev/nvme0n1p1   30G  1.7G   29G   6% /
tmpfs            16G     0   16G   0% /tmp
127.0.0.1:/     8.0E  245G  8.0E   1% /mnt/efs
tmpfs           3.2G     0  3.2G   0% /run/user/1000
```
