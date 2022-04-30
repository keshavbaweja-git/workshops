##!/bin/bash
CLUSTER_NAME=mycluster1
ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
OIDC_PROVIDER=$(aws eks describe-cluster --name $CLUSTER_NAME --query "cluster.identity.oidc.issuer" --output text | sed -e "s/^https:\/\///")

PROM_SERVICE_ACCOUNT_NAMESPACE=prometheus
GRAFANA_SERVICE_ACCOUNT_NAMESPACE=grafana
SERVICE_ACCOUNT_NAME=iamproxy-service-account
SERVICE_ACCOUNT_IAM_ROLE=EKS-AMP-ServiceAccount-Role
SERVICE_ACCOUNT_IAM_ROLE_DESCRIPTION="IAM role to be used by a K8s service account with write access to AMP"
SERVICE_ACCOUNT_IAM_POLICY=AWSManagedPrometheusWriteAccessPolicy
SERVICE_ACCOUNT_IAM_POLICY_ARN=arn:aws:iam::$ACCOUNT_ID:policy/$SERVICE_ACCOUNT_IAM_POLICY

echo "Creating a new trust policy"
read -r -d '' NEW_TRUST_RELATIONSHIP <<EOF
 [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::${ACCOUNT_ID}:oidc-provider/${OIDC_PROVIDER}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "${OIDC_PROVIDER}:sub": "system:serviceaccount:${GRAFANA_SERVICE_ACCOUNT_NAMESPACE}:${SERVICE_ACCOUNT_NAME}"
        }
      }
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::${ACCOUNT_ID}:oidc-provider/${OIDC_PROVIDER}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "${OIDC_PROVIDER}:sub": "system:serviceaccount:${PROM_SERVICE_ACCOUNT_NAMESPACE}:${SERVICE_ACCOUNT_NAME}"
        }
      }
    }
  ]
EOF

OLD_TRUST_RELATIONSHIP=$(aws iam get-role --role-name $SERVICE_ACCOUNT_IAM_ROLE --query 'Role.AssumeRolePolicyDocument.Statement[]' --output json)
COMBINED_TRUST_RELATIONSHIP=$(echo $OLD_TRUST_RELATIONSHIP $NEW_TRUST_RELATIONSHIP | jq -s add)
echo "Appending to the existing trust policy"
read -r -d '' TRUST_POLICY <<EOF
{
  "Version": "2012-10-17",
  "Statement": ${COMBINED_TRUST_RELATIONSHIP}
}
EOF
echo "${TRUST_POLICY}" > TrustPolicy.json


read -r -d '' PERMISSION_POLICY <<EOF
{
   "Version":"2012-10-17",
   "Statement":[
      {
         "Effect":"Allow",
         "Action":[
            "aps:RemoteWrite",
            "aps:QueryMetrics",
            "aps:GetSeries",
            "aps:GetLabels",
            "aps:GetMetricMetadata"
         ],
         "Resource":"*"
      }
   ]
}
EOF
echo "${PERMISSION_POLICY}" > PermissionPolicy.json


aws iam create-policy --policy-name $SERVICE_ACCOUNT_IAM_POLICY --policy-document file://permission-policy.json 


SERVICE_ACCOUNT_IAM_ROLE_ARN=$(aws iam create-role \
--role-name $SERVICE_ACCOUNT_IAM_ROLE \
--assume-role-policy-document file://trust-policy.json \
--description "$SERVICE_ACCOUNT_IAM_ROLE_DESCRIPTION" \
--query "Role.Arn" --output text)

aws iam attach-role-policy --role-name $SERVICE_ACCOUNT_IAM_ROLE --policy-arn $SERVICE_ACCOUNT_IAM_POLICY_ARN  
echo $SERVICE_ACCOUNT_IAM_ROLE_ARN

