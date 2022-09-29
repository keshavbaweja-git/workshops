mwaa_iam_role=AmazonMWAA-MyAirflowEnvironment-WD4gNN

aws iam attach-role-policy \
--role-name $mwaa_iam_role \
--policy-arn arn:aws:iam::aws:policy/AWSGlueConsoleFullAccess

aws iam attach-role-policy \
--role-name $mwaa_iam_role \
--policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess