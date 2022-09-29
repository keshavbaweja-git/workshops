glue_role_name=AWSGlueServiceRoleDefault

aws iam create-role \
--role-name $glue_role_name \
--assume-role-policy-document file://011-trust-relationship.json \
--description "AWSGlueServiceRoleDefault"

aws iam attach-role-policy \
--role-name $glue_role_name \
--policy-arn arn:aws:iam::aws:policy/AWSGlueConsoleFullAccess

aws iam attach-role-policy \
--role-name $glue_role_name \
--policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess