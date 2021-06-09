Steps to test the issue:

Dockerfile
```
FROM nginx
RUN apt-get update -y && apt-get install procps lsof -y
COPY . .
CMD ["bash", "./entrypoint.sh"]
```
entrypoint.sh
```
#/bin/bash
sleep 30
ps aux|grep ssm
lsof /var/lib/amazon/ssm/ipc/health
cat /var/log/amazon/ssm/amazon-ssm-agent.log
nginx -g "daemon off;"
```
Container Health Check Configuration
```
"healthCheck": {
        "retries": 5,
        "command": [
          "CMD-SHELL",
          "curl -f http://localhost/ || exit 1"
        ],
        "timeout": 10,
        "interval": 30,
        "startPeriod": 10
      },
```
Add the correct permission for the IAM Task Role and create the service with the below command:
```
aws ecs create-service \
    --cluster cluster-name \
    --task-definition task-definition-name \
    --enable-execute-command \
    --service-name service-name
    --desired-count 10
```
It will start a service with 10 tasks. Now, you can check which one is having SSM Agent issue with the following command:

```
# for i in `aws ecs list-tasks --cluster cluster-name --service-name service-name | jq '.taskArns | .[]'| cut -d"/" -f 3 |cut -d\" -f 1` ; do echo "Task ID: "$i" : "; aws ecs describe-tasks --cluster cluster-name --tasks $i | jq '.tasks[0].containers[].managedAgents[0].lastStatus' ; done
```
