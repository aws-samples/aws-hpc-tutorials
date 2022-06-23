+++
title = "d. No-Ingress DCV Session"
date = 2019-09-18T10:46:30-04:00
weight = 13
tags = ["tutorial", "NICE DCV", "ParallelCluster", "Remote Desktop"]
+++

## No-Ingress DCV

An alternative to the above approach where we opened up the Security Group to allow traffic from port `8443` is to create a Port Forwarding Session with AWS SSM. This allows us to lock down the Security Group and have no ingress. The disadvantage is we pay a performance penalty since all the traffic is port forwarded through SSM.

1. Install [Session Manager Plugin](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html) locally, following the instructions for your local OS.

2. Submit a job using the following submit script:
```bash
#!/bin/bash
#SBATCH -p desktop
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

instance_id=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
printf "\e[32mFor a no-ingress cluster, you'll need to run the following command (on your local machine):\e[0m"
printf "\n=> \e[37m\taws ssm start-session --target $instance_id --document-name AWS-StartPortForwardingSession --parameters '{\"portNumber\":[\"8443\"],\"localPortNumber\":[\"8443\"]}'\e[0m\n"

printf "\n\n\e[32mThen click the following URL to connect:\e[0m"
printf "\n=> \e[34mhttps://localhost:8443?username=ec2-user&password=$password\e[0m\n"

while true; do
   sleep 1
done;
```

2. Submit a job to start a session:

```bash
sbatch desktop.sbatch # note the job id
```

3. Once the job starts running, check the file `cat desktop-[job-id].out` for connection instructions:

![image](/images/nice-dcv/no-ingress-dcv.png)

4. Run the SSM port forwarding command **on your local machine**

5. Connect to the `http://localhost:8443` URL printed in the job output.