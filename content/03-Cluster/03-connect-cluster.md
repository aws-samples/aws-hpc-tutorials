---
title: "c. Connect to the Cluster"
weight: 33
tags: ["tutorial", "connecting", "ParallelCluster"]
---

The cluster we created on the previous page takes about ~15 mins to create. While you're waiting grab a ☕️.

Once the cluster goes into **CREATE COMPLETE**, we can connect to the head node in one of two ways, either through the shell or via the DCV session:

**SSM Session Manager** is ideal for quick terminal access to the head node, it doesn't require any ports to be open on the head node, however it does require you to authenticate with the AWS account the instance it running in.

**SSH** can be used to connect to the cluster from a standard SSH client. This can be configured to use your own key via adding the public key or a new key can be provisioned.

## SSM Connect

1. Click on the **Shell** Button to connect:

![SSM Connect](/images/03-cluster/ssm-connect.png)

You'll need to be authenticated to the AWS account that instance is running in and have [permission to launch a SSM session](https://docs.aws.amazon.com/systems-manager/latest/userguide/getting-started-add-permissions-to-existing-profile.html). Once you're connected you'll have access to a terminal on the head node:

Now change to `ubuntu` user:

    ```bash
    echo "sudo su - ubuntu" >> ~/.bashrc && source ~/.bashrc
    ```

![SSM Console](/images/03-cluster/ssm-console.png)

## SSH {#ssh}

1. First create a ssh key for the user you want to connect as, hit enter several times to accept the defaults:

    ```bash
    $ ssh-keygen
    Generating public/private rsa key pair.
    Enter file in which to save the key (/home/ubuntu/.ssh/id_rsa):
    Enter passphrase (empty for no passphrase):
    Enter same passphrase again:
    Your identification has been saved in /home/ubuntu/.ssh/id_rsa
    Your public key has been saved in /home/ubuntu/.ssh/id_rsa.pub
    The key fingerprint is:
    SHA256:R7DXrzG+QWyfv3O0ojIyXzxRuvx/Bfc26bMDj7e4Tzs ubuntu@ip-10-0-21-30
    The key's randomart image is:
    +---[RSA 3072]----+
    |        .        |
    |         o .     |
    |        . o ..   |
    |         o .o.. .|
    |        S .o* .oo|
    |         .o+o* +=|
    |           *+ B++|
    |       o o. o=oE+|
    |        +.o.o+*B%|
    +----[SHA256]-----+
    ```

2. Now add the public key you just created to the `~/.ssh/authorized_keys` file. This will enable users to login as long as they have the corresponding private key file:

    ```bash
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
    ```

2. Next copy the private key file to a file on your local machine:

    ```bash
    cat ~/.ssh/id_rsa
    ```

3. Now you can ssh into the HeadNode where `public-ip` is the ip address of the HeadNode:

    ```bash
    ssh -i ~/path/private/key ubuntu@public-ip
    ```