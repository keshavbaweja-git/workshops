ACCOUNT_ID=$(aws sts get-caller-identity | jq -r .Account)

bucket_name=$ACCOUNT_ID-pinnacle-mwaa

aws s3 mb s3://$bucket_name
aws s3api put-bucket-versioning --bucket $bucket_name \
--versioning-configuration Status=Enabled

aws s3api put-public-access-block --bucket $bucket_name \
--public-access-block-configuration BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true


aws s3 cp data_pipeline.py s3://$bucket_name/dags/
aws s3api put-object --bucket $bucket_name --key data/

aws s3 cp ./scripts/glue/nyc_raw_to_transform.py s3://$bucket_name/scripts/glue/

aws_airflows_lib=awsairflowlib_222.zip
curl --output $aws_airflows_lib https://static.us-east-1.prod.workshops.aws/public/540a27d2-ca08-4c01-b181-2e540a9bd1b3/static/packages/$aws_airflows_lib
aws s3 cp ./$aws_airflows_lib s3://$bucket_name/plugins/
rm ./$aws_airflows_lib

aws s3 cp ./requirements.txt s3://$bucket_name/requirements/





