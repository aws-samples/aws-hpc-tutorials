---
title: "d. Jupyter Hub"
weight: 15
tags: ["tutorial", "cloud9", "ParallelCluster"]
---

[Jupyter Hub](https://jupyter.org/) (formerly known as iPython Notebooks) is a powerful tool for running python code in an interactive and easily reaptable way. In this section we'll setup the `llama-recipes` jupyter notebook on the HeadNode of our cluster.


1. First install Jupyter Hub 

```bash
# install npm and configurable-http-proxy
sudo apt install npm
sudo npm install -g configurable-http-proxy

# install jupyter hub
python3 -m pip install jupyterhub
python3 -m pip install jupyterlab notebook  # needed if running the notebook servers in the same environment

# check the install:
jupyterhub -h
configurable-http-proxy -h

# start the server
sudo python3 -m jupyterhub
```

2. Next we're going to start a port forwarding session on our local machine. This allows us to keep the security group of the HeadNode locked down while allowing us to securely connect. You can read more about SSM Port Forwarding [here](https://aws.amazon.com/blogs/aws/new-port-forwarding-using-aws-system-manager-sessions-manager/). You'll need to [install the aws cli](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) and [setup credentials](https://docs.aws.amazon.com/cli/latest/userguide/cli-authentication-short-term.html) on your local machine first.

```bash
aws ssm start-session --target i-04bfb6c1667411b9d --document-name AWS-StartPortForwardingSession --parameters "portNumber=['8888'],localPortNumber=['8888']"
```

3. Now you can access the node by copying the url from the jupyter server command we ran above:

![Jupyter URL](/images/06-llama2/jupyter-url.png)

You should see a URL like: [**http://localhost:8888/lab**](http://localhost:8888/lab)

Click on that to connect.