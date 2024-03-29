#!/bin/bash

ClusterName=mycluster5
RegionName=ap-southeast-1
FargateProfileName=fargate-productcatalog
AccountId=$(aws sts get-caller-identity --query "Account" --output text)
PodExecutionRoleName=$(aws eks describe-fargate-profile --cluster-name $ClusterName --fargate-profile-name $FargateProfileName --query fargateProfile.podExecutionRoleArn --output text | cut -d "/" -f 2)
echo "PodExecutionRoleName: $PodExecutionRoleName"

curl -o permissions.json \
https://raw.githubusercontent.com/aws-samples/amazon-eks-fluent-logging-examples/mainline/examples/fargate/cloudwatchlogs/permissions.json

aws iam create-policy \
--policy-name FluentBitEKSFargate \
--policy-document file://permissions.json 

rm permissions.json

aws iam attach-role-policy \
--role-name $PodExecutionRoleName \
--policy-arn arn:aws:iam::$AccountId:policy/FluentBitEKSFargate

