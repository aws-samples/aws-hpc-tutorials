#!/bin/bash
/usr/sbin/sshd -D -f /root/.ssh/sshd_config -h /root/.ssh/ssh_host_rsa_key &
while true; do date; sleep 60; done
#tail -f /dev/null