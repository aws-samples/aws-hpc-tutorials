---
title : "d. Create Launch Template with User Data"
date: 2022-07-22T15:58:58Z
weight : 40
tags : ["configuration", "vpc", "subnet", "iam", "pem"]
---

In this step, you create the EC2 launch template with the user data to mount the EFS. The process involves creation of a json configuration that will be used to create the launch template using aws cli. 

### Log into AWS Cloud9
1. Log into your AWS Cloud9 that you created in the previous step
2. Use the template with placeholders as a starting point to create the base template
3. Incorporate the userdata section with specific commands to run during instance initialization
4. Insert the userdata section as byte encoded text into the template file
5. Use aws cli to create the launch template

### Byte Encode the YAML file for User Data

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
- efs_file_system_id_01=EFS_MOUNT_DNS
- efs_directory=/mnt/efs
- mkdir -p ${efs_directory}
- echo "${efs_file_system_id_01}:/ ${efs_directory} efs tls,_netdev" >> /etc/fstab
- mount -a -t efs defaults

- mkdir -p /scratch

--==MYBOUNDARY==--
```

Save this file as **efs_ecs_user_data.yml** in the working directory

Replace the placeholders in YAML file
| PlaceHolder     	| Replace With                 	|
|-----------------	|------------------------------	|
| EFS_MOUNT_DNS 	| full dns name of the efs dns (No Quotes) 	|

Create a base64 encoded string of this YAML file suitable for internet transmission

```angular2html
base64 -w 0 efs_ecs_user_data.yml
```

{{% notice info %}}
It is very important to create it as a single line of text without any wrapping by the terminal. A sample output is shown below and the encoded string will be used in the subsequent section
{{% /notice %}}

```bash
~/environment/create_launch_template_dl1/template $ base64 -w 0 efs_ecs_launch_template.yml 
TUlNRS1WZXJzaW9uOiAxLjAKQ29udGVudC1UeXBlOiBtdWx0aXBhcnQvbWl4ZWQ7IGJvdW5kYXJ5PSI9PU1ZQk9VTkRBUlk9PSIKCi0tPT1NWUJPVU5EQVJZPT0KQ29udGVudC1UeXBlOiB0ZXh0L2Nsb3VkLWNvbmZpZzsgY2hhcnNldD0idXMtYXNjaWkiCgpwYWNrYWdlczoKLSBhbWF6b24tZWZzLXV0aWxzCgpydW5jbWQ6Ci0gZWZzX2ZpbGVfc3lzdGVtX2lkXzAxPTxFRlMgTU9VTlQgRE5TPgotIGVmc19kaXJlY3Rvcnk9L21udC9lZnMKLSBta2RpciAtcCAke2Vmc19kaXJlY3Rvcnl9Ci0gZWNobyAiJHtlZnNfZmlsZV9zeXN0ZW1faWRfMDF9Oi8gJHtlZnNfZGlyZWN0b3J5fSBlZnMgdGxzLF9uZXRkZXYiID4+IC9ldGMvZnN0YWIKLSBtb3VudCAtYSAtdCBlZnMgZGVmYXVsdHMKCi0gbWtkaXIgLXAgL3NjcmF0Y2gKCi0tPT1NWUJPVU5EQVJZPT0tLQ==
```

### Creating the launch template

The json file with the templates with placeholders are provided below. Copy this to a file called **ecs_launch_template.json** and update the place holder values

```json
{
  "DryRun": false,
  "LaunchTemplateName": "ECS_DL1_EFS",
  "VersionDescription": "Override Template",
  "LaunchTemplateData": {
    "IamInstanceProfile": {
      "Arn": "INSTANCE_PROFILE"
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
        "AssociatePublicIpAddress": false,
        "DeleteOnTermination": true,
        "DeviceIndex": 0,
        "Groups": [
          "SECURITY_GROUP"
        ],
        "InterfaceType": "efa",
        "Ipv6AddressCount": 0,
        "SubnetId": "SUBNET",
        "NetworkCardIndex": 0
      }
    ],
    "ImageId": "ami-0d869a3f36bb26f73",
    "KeyName": "PEM_KEY_NAME",
    "Monitoring": {
      "Enabled": true
    },
    "DisableApiTermination": false,
    "InstanceInitiatedShutdownBehavior": "stop",
    "UserData": "USER_DATA",
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
{{% notice info %}}
**Note: When you are entering strings inside JSON file, it has to be quoted for a valid json**
{{% /notice %}}

| PlaceHolder      	| Replace With                                                           	|
|------------------	|------------------------------------------------------------------------	|
| INSTANCE_PROFILE 	| arn:aws:iam::xxxxxxxxxxx:instance-profile/ecsInstanceRole 	|
| SECURITY_GROUP   	| sg-xxxxxxxxx                                              	|
| SUBNET           	| subnet-xxxxxxxx                                         	|
| PEM_KEY_NAME     	| key_name_no_extension                                         	|
| USER_DATA       	| Base64 encoded string from YAML file                                         	|

#### Create Launch template with aws cli

```bash
aws ec2 create-launch-template --cli-input-json file://ecs_launch_template.json
```

Upon successful execution, it will output the LaunchTemplateId and LaunchTemplateName. 
```json
{
    "LaunchTemplate": {
        "LaunchTemplateId": "lt-xxxxxxxxx",
        "LaunchTemplateName": "ECS_DL1_EFS",
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
