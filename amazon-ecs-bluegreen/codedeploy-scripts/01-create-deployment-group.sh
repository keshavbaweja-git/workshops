ACCOUNT_ID=$(aws sts get-caller-identity | jq -r .Account)
envsubst < bluegreen-deployment-group-template.json > bluegreen-deployment-group.json

aws deploy create-deployment-group \
--cli-input-json file://bluegreen-deployment-group.json
 