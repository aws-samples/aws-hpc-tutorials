+++
title = "c. Create DCV Session"
date = 2019-09-18T10:46:30-04:00
weight = 12
tags = ["tutorial", "NICE DCV", "ParallelCluster", "Remote Desktop"]
+++

1. Now connect to your cluster and create a file called `desktop.sbatch` with the following contents:

```bash
#!/bin/bash
#SBATCH -p dcv
#SBATCH -t 12:00:00
#SBATCH -J desktop
#SBATCH -o "%x-%j.out"

# magic command to disable lock screen
dbus-launch gsettings set org.gnome.desktop.session idle-delay 0 > /dev/null
# Set a password
password=$(openssl rand -base64 32)
echo $password | sudo passwd ec2-user --stdin > /dev/null
# start DCV server and create session
sudo systemctl start dcvserver
dcv create-session $SLURM_JOBID

ip=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
printf "\e[32mClick the following URL to connect:\e[0m"
printf "\n=> \e[34mhttps://$ip:8443?username=ec2-user&password=$password\e[0m\n"

while true; do
   sleep 1
done;
```

2. Submit a job to start a session:

```bash
sbatch desktop.sbatch # note the job id
```

3. Once the job starts running, check the file `cat desktop-[job-id].out` for connection details:

![image](/images/nice-dcv/nice-dcv-session.png)

4. Click on the URL to connect to the DCV instance