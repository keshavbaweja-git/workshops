ACCOUNT_ID=$(aws sts get-caller-identity | jq -r .Account)

bucket_name=$ACCOUNT_ID-pinnacle-mwaa

aws s3 cp s3://ee-assets-prod-us-east-1/modules/f8fe356a07604a12bec0b5582be38aed/v1/data/green_tripdata_2020-06.csv \
s3://$bucket_name/data/raw/green/
