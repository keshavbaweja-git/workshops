ACCOUNT_ID=$(aws sts get-caller-identity | jq -r .Account)
envsubst < bluegreen-deployment-group-template.json > bluegreen-deployment-group.json
