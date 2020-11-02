#!/bin/bash

aws ecs update-service --cluster ${ECS_CLUSTER_NAME}  --service dashboard --desired-count 0
sleep 10
aws ecs delete-service --cluster ${ECS_CLUSTER_NAME}  --service dashboard
aws elbv2 delete-listener --listener-arn ${LISTENER_ARN}
aws elbv2 delete-target-group --target-group-arn ${DASHBOARD_TARGET_GROUP_ARN}
aws elbv2 delete-load-balancer --load-balancer-arn ${ALB_ARN}
aws ec2 delete-security-group --group-id ${ALB_SECURITY_GROUP_ID}

aws ecs update-service --cluster ${ECS_CLUSTER_NAME}  --service counting --desired-count 0
sleep 10
aws ecs delete-service --cluster ${ECS_CLUSTER_NAME}  --service counting

aws iam delete-role-policy --role-name Dashboard-Service-Role --policy-name Dashboard-Service-Policy
aws iam delete-role-policy --role-name Counting-Service-Role --policy-name Counting-Service-Policy
aws iam delete-role --role-name Dashboard-Service-Role
aws iam delete-role --role-name Counting-Service-Role

aws secretsmanager delete-secret --secret-id ${DASHBOARD_SECRET_ARN} --force-delete-without-recovery
aws secretsmanager delete-secret --secret-id ${COUNTING_SECRET_ARN} --force-delete-without-recovery
aws ecs deregister-task-definition --task-definition ${DASHBOARD_TASK_DEFINITION_ARN}
aws ecs deregister-task-definition --task-definition ${COUNTING_TASK_DEFINITION_ARN}

aws ecs delete-service --cluster ${ECS_CLUSTER_NAME}  --service consul-client
aws secretsmanager delete-secret --secret-id ${CONSUL_CLIENT_SECRET_ARN} --force-delete-without-recovery
aws iam delete-role-policy --role-name Consul-Client-Role --policy-name Consul-Client-Policy
aws iam delete-role --role-name Consul-Client-Role
aws ecs deregister-task-definition --task-definition ${CONSUL_CLIENT_TASK_DEFINITION_ARN}

