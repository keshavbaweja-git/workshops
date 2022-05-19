ACCOUNT_ID=$(aws sts get-caller-identity | jq -r .Account)
envsubst < appspec-template.yaml > appspec.yaml
aws s3 mb s3://keshavkb-3-bluegreen-bucket
aws s3 cp ./appspec.yaml s3://keshavkb-3-bluegreen-bucket/appspec.yaml