aws iam create-role \
--role-name ecsInstanceRole \
--assume-role-policy-document file://ecs-container-instance-trust-policy.json
