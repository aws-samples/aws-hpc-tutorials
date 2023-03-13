#!/bin/bash
# Requires Environment Variables: SECRETMANAGER_KEY_NAME, HOME
python /extract_key.py
echo "Extracted secrets from Secret Manager for sshd setup"
SSHDIR=$HOME/.ssh
chmod -R 600 ${SSHDIR}/*
eval `ssh-agent -s` && ssh-add ${SSHDIR}/id_rsa
echo "Prepared files for sshd server start"
echo "Starting sshd"
/usr/sbin/sshd -D -f /root/.ssh/sshd_config -h /root/.ssh/ssh_host_rsa_key
