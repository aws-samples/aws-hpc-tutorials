---
title: "e. Create AMI"
date: 2022-08-19
weight: 60
tags: ["Ray", "AMI"]
---

It’s preferable to create an AMI instead to be used for all cluster nodes with the required packages pre-installed. It make it much faster to spin up a cluster as compared to installing all the packages on the fly at the time of cluster creation.

Launch an EC2 instance from AWS console.

- Select AWS Deep Learning Base AMI GPU CUDA 11 (Ubuntu 20.04) AMI to start with
- Select g4dn.xlarge instance type
- Select the key-pair you created earlier in this workshop
- Keep rest of the settings as default and launch the instance

It takes few minutes for the instance to be available. Once the instance is ready, ssh to this instance from Cloud9 terminal using the private ip address of the instance just created:

```bash
ssh -i your_key.pem ubuntu@10.0.xxx.xxx
```
We are going to install the following packages in this instance:

- miniconda
- ray (2.0)
- PyTorch
- FSxL client

Use the following list of command to complete the setup:

Update system:
```bash
sudo apt update && sudo apt upgrade -y
```

Set up conda:
```bash
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/anaconda3
./anaconda3/bin/conda init
source .bashrc
pip install --upgrade pip
```

Install ray:
```bash
pip install ray[air]
```

Install PyTorch:
```bash
conda install -y pytorch torchvision cudatoolkit=11.6 -c pytorch -c conda-forge
```

Install FSx for Luster client (Ubuntu 20.04):
```bash
wget -O - https://fsx-lustre-client-repo-public-keys.s3.amazonaws.com/fsx-ubuntu-public-key.asc | gpg --dearmor | sudo tee /usr/share/keyrings/fsx-ubuntu-public-key.gpg >/dev/null
sudo bash -c 'echo "deb [signed-by=/usr/share/keyrings/fsx-ubuntu-public-key.gpg] https://fsx-lustre-client-repo.s3.amazonaws.com/ubuntu focal main" > /etc/apt/sources.list.d/fsxlustreclientrepo.list && apt-get update'
sudo apt install -y lustre-client-modules-$(uname -r)
```

Create mount point for FSxL
```bash
sudo mkdir /fsx
sudo chmod 777 /fsx
```

After this setup, exit the instance.

Navigate to the EC2 console, select the instance and click on Actions button. From the dropdown, select Image and templates, and click on Create image. In the create image wizard, just provide a name and description and click on Create image. This process can take up to 10 minutes to create an AMI. To check the progress, click AMIs under Images in the left pan. You will see new AMI in the list. Once the status of AMI changes to from Pending to Available, terminate the EC2 instance. Note that we will need the AMI id for later use.
