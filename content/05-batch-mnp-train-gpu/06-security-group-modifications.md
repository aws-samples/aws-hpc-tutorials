---
title : "f. Modifications to Security Group for NCCL + Communication"
date: 2022-07-22T15:58:58Z
weight : 70
tags : ["configuration", "vpc", "subnet", "iam", "pem"]
---

In this step, you will make modifications to the security group so that it will permit non-TCP connections between the nodes. This is useful for nodes that have EFA based communication between the nodes.

In this step,
- Create the ssh key (private and public) on your machine
- Upload the ssh key into the AWS Secrets Manager  
- Make modifications to the security group so that it will permit EFA based communication between nodes

### SSH Keys + AWS Secret Manager
- Create the ssh key on your local machine
```textmate
ssh-keygen -t rsa -f ssh_host_rsa_key -N ''
```
This step will create a public and a private key in the current folder
```textmate
ubuntu@ip-172-31-9-117:~/scratch/temp_secrets$ ls -lrt ssh*
-rw-r--r-- 1 ubuntu ubuntu  404 Aug 22 18:56 ssh_host_rsa_key.pub
-rw------- 1 ubuntu ubuntu 1675 Aug 22 18:56 ssh_host_rsa_key
```
- base64 encode the private and public keys so that it can be transmitted over the internet without any issues of mangling the content
```
cat ssh_host_rsa_key | base64 | tr -d \\n
cat ssh_host_rsa_key.pub | base64 | tr -d \\n
```
The newline characters will be stripped in the output and carefully select the portion of the string till the start of the next command prompt
- From the console for AWSSecretsManager --> Store a new secret --> Create a new Secret --> Select plain text. Leave the Encryption Key as default as aws/secretsmanager
![SecretsManager](/images/batch_mnp/secrets_manager_empty.png)
- Create two name values pairs with the names as MPI_SSH_KEY_PRIVATE & MPI_SSH_KEY_PUBLIC to assign their respective encoded strings. A sample is shown below for reference
![SecretsManager Name Value](/images/batch_mnp/secrets_manager_filled.png)
- Save the secret under the name MPI_SSH_KEY. The Secrets Manager will provide a ARN for referring to in the future (job description) to fetch the values.
![SecretsManager ARN](/images/batch_mnp/secrets_arn.png)  
- In order to access the secret during the ECS task launch, the ecsTaskExecution Role should have the policy to access the Secrets Manager
![Secrets Policy][/images/batch_mnp/ecsTaskExecRole_Secrets.png]
  
### Security Group Modifications

{{% notice info %}}
Though the g5 instance selected does not have EFA, one would need this step to be performed for using p3dn, p4d, p4de and p5.
{{% /notice %}} 


Edit the inbound and outbound rules of the security group to permit All Traffic, All Protocols, All Ports from the source as the "same" security group. Though this seems obvious, it is essential to permit the instances to communicate with each other other than TCP.

- Inbound Rules Modification
![Inbound Rules](/images/batch_mnp/sg_inbound_rules.png)

- Outbound Rules Modification
![Outbound Rules](/images/batch_mnp/sg_outbound_rules.png)
