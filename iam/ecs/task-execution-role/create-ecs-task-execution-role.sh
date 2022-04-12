aws iam create-role \
--role-name ecsTaskExecutionRole \
--assume-role-policy-document file://ecs-tasks-trust-policy.json
