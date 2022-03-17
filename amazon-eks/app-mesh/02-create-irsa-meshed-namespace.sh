#!/bin/bash

# Download the IAM policy document for the Envoy proxies
curl -o envoy-iam-policy.json https://raw.githubusercontent.com/aws/aws-app-mesh-controller-for-k8s/master/config/iam/envoy-iam-policy.json

# Create an IAM policy for the proxies from the policy document
aws iam create-policy \
--policy-name AWSAppMeshEnvoySidecarIAMPolicy \
--policy-document file://envoy-iam-policy.json
echo "Created IAM policy for envoy sidecar permissions"

# Create an IAM role and service account for the application namespace
eksctl create iamserviceaccount \
--cluster $CLUSTER_NAME \
--namespace prod \
--name default \
--attach-policy-arn arn:aws:iam::$ACCOUNT_ID:policy/AWSAppMeshEnvoySidecarIAMPolicy  \
--override-existing-serviceaccounts \
--approve
echo "Updated IAM role for default SA with envoy policy"
