ACCOUNT_ID=$(aws sts get-caller-identity | jq -r .Account)

bucket_name=$ACCOUNT_ID-pinnacle-mwaa
aws s3 mb s3://$bucket_name
aws s3api put-object --bucket $bucket_name --key dags/
aws s3api put-object --bucket $bucket_name --key data/

aws s3api put-object --bucket $bucket_name --key scripts/
aws s3api put-object --bucket $bucket_name --key scripts/glue
aws s3api put-object --bucket $bucket_name --key scripts/emr

aws s3api put-object --bucket $bucket_name --key plugins/
aws_airflows_lib=awsairflowlib_222.zip
curl --output $aws_airflows_lib https://static.us-east-1.prod.workshops.aws/public/540a27d2-ca08-4c01-b181-2e540a9bd1b3/static/packages/$aws_airflows_lib
aws s3 cp ./$aws_airflows_lib s3://$bucket_name/plugins/
rm ./$aws_airflows_lib

aws s3api put-object --bucket $bucket_name --key requirements/
aws s3 cp ./requirements.txt s3://$bucket_name/requirements/





