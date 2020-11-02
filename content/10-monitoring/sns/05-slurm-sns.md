+++
title = "d. Slurm Job Notification using SNS"
date = 2019-09-18T10:46:30-04:00
weight = 400
tags = ["tutorial", "Monitoring", "ParallelCluster", "SNS", "Slurm", "Job Notification"]
+++

- In the AWS Cloud9 terminal login to the head node of your cluster (if not logged in already)

```bash
pcluster ssh perflab-yourname -i ~/.ssh/lab-4-key
```

- Confirm if the `REGION` and `MY_SNS_TOPIC` variables are set. If not please set as follows:

```bash
REGION=$(curl --silent http://169.254.169.254/latest/dynamic/instance-identity/document|grep region|awk -F\" '{print $4}')
MY_SNS_TOPIC=$(aws sns list-topics --query 'Topics[]' --output text --region $REGION | grep "slurm-job-completion")
```

- Create an example Slurm job script as follows:

```bash
cat > job-sns.sh << EOF
#!/bin/bash
#SBATCH --nodes=2
#SBATCH --time=10:00

hostname
sleep 5
aws sns publish --message "Your \${SLURM_JOB_NAME} with Job ID \${SLURM_JOB_ID} is complete" --topic $MY_SNS_TOPIC --region $REGION
EOF
```

- Submit the script to SLURM using the SBATCH command as follows:

```bash
sbatch job-sns.sh
```

- Once the job completes, you should receive a Job completion notification via email. The email should be something like below:

<!-- TODO Update IMAGE -->
![SNS TOPIC](/images/monitoring/sns-topic-publish-email.png)


Next, we will tear down the cluster and resources that you created as part of this lab.
