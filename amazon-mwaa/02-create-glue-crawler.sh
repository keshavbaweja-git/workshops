ACCOUNT_ID=$(aws sts get-caller-identity | jq -r .Account)

aws glue create-crawler \
--name airflow-workshop-raw-green-crawler \
--role arn\:aws\:iam::$ACCOUNT_ID\:role/AWSGlueServiceRoleDefault \
--database-name default \
--targets "{\"S3Targets\":[{\"Path\":\"s3://696933599340-pinnacle-mwaa/data/raw/green\"}]}"

