#/bin/bash
sleep 30
ps aux|grep ssm
lsof /var/lib/amazon/ssm/ipc/health
cat /var/log/amazon/ssm/amazon-ssm-agent.log
nginx -g "daemon off;"