role_name=ApiGatewayRole

aws iam create-role \
--role-name $role_name \
--assume-role-policy-document file://trust-relationship.json \
--description $role_name

aws iam attach-role-policy \
--role-name $role_name \
--policy-arn arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs