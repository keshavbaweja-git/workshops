##!/bin/bash
CLUSTER_NAME=mycluster1
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
OIDC_PROVIDER=$(aws eks describe-cluster --name $CLUSTER_NAME --query "cluster.identity.oidc.issuer" --output text | sed -e "s/^https:\/\///")

PROM_SERVICE_ACCOUNT_NAMESPACE=prometheus
GRAFANA_SERVICE_ACCOUNT_NAMESPACE=grafana
SERVICE_ACCOUNT_NAME=iamproxy-service-account
SERVICE_ACCOUNT_IAM_ROLE=EKS-AMP-ServiceAccount-Role
SERVICE_ACCOUNT_IAM_ROLE_DESCRIPTION="IAM role to be used by a K8s service account with write access to AMP"
SERVICE_ACCOUNT_IAM_POLICY=AWSManagedPrometheusWriteAccessPolicy
SERVICE_ACCOUNT_IAM_POLICY_ARN=arn:aws:iam::$AWS_ACCOUNT_ID:policy/$SERVICE_ACCOUNT_IAM_POLICY

aws iam create-policy --policy-name $SERVICE_ACCOUNT_IAM_POLICY --policy-document file://permission-policy.json 


SERVICE_ACCOUNT_IAM_ROLE_ARN=$(aws iam create-role \
--role-name $SERVICE_ACCOUNT_IAM_ROLE \
--assume-role-policy-document file://trust-policy.json \
--description "$SERVICE_ACCOUNT_IAM_ROLE_DESCRIPTION" \
--query "Role.Arn" --output text)

aws iam attach-role-policy --role-name $SERVICE_ACCOUNT_IAM_ROLE --policy-arn $SERVICE_ACCOUNT_IAM_POLICY_ARN  
echo $SERVICE_ACCOUNT_IAM_ROLE_ARN

