#!/bin/bash
CLUSTER_NAME=mycluster3
REGION=ap-southeast-1
SERVICE_ACCOUNT_NAMESPACE=fargate-container-insights
SERVICE_ACCOUNT_NAME=adot-collector
SERVICE_ACCOUNT_IAM_ROLE=EKS-Fargate-ADOT-ServiceAccount-Role
SERVICE_ACCOUNT_IAM_POLICY_ARN=arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy
IRSA_NAME=AdotCollectorFargate

account_id=$(aws sts get-caller-identity \
--query "Account" --output text)

oidc_provider=$(aws eks describe-cluster --name $CLUSTER_NAME \
--query "cluster.identity.oidc.issuer" --output text \
| sed -e "s/^https:\/\///")


cat >trust-relationship.json <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::$account_id:oidc-provider/$oidc_provider"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "$oidc_provider:aud": "sts.amazonaws.com",
          "$oidc_provider:sub": "system:serviceaccount:$SERVICE_ACCOUNT_NAMESPACE:$SERVICE_ACCOUNT_NAME"
        }
      }
    }
  ]
}
EOF

aws iam create-role \
--role-name $IRSA_NAME \
--assume-role-policy-document file://trust-relationship.json \
--description "ADOT Collector Fargate"

rm trust-relationship.json

aws iam attach-role-policy \
--role-name $IRSA_NAME \
--policy-arn=$SERVICE_ACCOUNT_IAM_POLICY_ARN


kubectl apply -f adot-fargate-sa.yaml

curl https://raw.githubusercontent.com/aws-observability/aws-otel-collector/main/deployment-template/eks/otel-fargate-container-insights.yaml \
| sed 's/ClusterName=YOUR-EKS-CLUSTER-NAME/ClusterName='$CLUSTER_NAME'/' \
| sed 's/region: us-east-1/region: '$REGION'/' \
| kubectl apply -f -
