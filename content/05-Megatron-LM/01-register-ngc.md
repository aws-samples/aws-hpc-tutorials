---
title: "a. Nvidia Container Registry (NGC)"
weight: 10
tags: ["tutorial", "cloud9", "ParallelCluster"]
---

![NGC Hub](/images/04-Megatron-LM/ngc.png)

[Nvidia Container Registry (NGC)](https://catalog.ngc.nvidia.com/containers) is a container registry that contains pre-built images optimized for Nvidia GPU's. This includes images for [Pytorch](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/pytorch), [Nemomegatron](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/nemo), [BERT](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/bert_workshop), ect. In the following example we're going to use the `pytorch:23.01-py3` image as the base for our Megatron-LM image.

The first step is to authenticate with NGC, this will allow us to pull down images from ngc.io.

1. Register for account on [https://ngc.nvidia.com](https://ngc.nvidia.com)

2. Login and fetch your API key, see [Nvidia Docs](https://docs.nvidia.com/dgx/ngc-registry-for-dgx-user-guide/index.html#migrating-from-dgx-registry-to-ngc__section_rqd_v5d_2nb) for instructions on how to do that.

3. Next install the NGC cli on your **HeadNode** like so:

```bash
wget --content-disposition https://ngc.nvidia.com/downloads/ngccli_linux.zip && unzip ngccli_linux.zip && chmod u+x ngc-cli/ngc
echo "export PATH=$(pwd)/ngc-cli:\$PATH" >> ~/.bashrc
source ~/.bashrc
```

3. Using the API key you generated, login to your account on the **HeadNode** like so:

```bash
ngc config set
```

4. The login with docker, make sure to put the username as `$oauthtoken` and password is the API key from NGC.

```
ubuntu@ip-10-0-21-26:~$ docker login nvcr.io
Username: $oauthtoken
Password:

WARNING! Your password will be stored unencrypted in /home/ubuntu/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
```

5. To test that it's working we'll fetch the `nemo:23.06` from NGC:

```bash
docker pull nvcr.io/nvidia/nemo:23.06
```