#!/bin/bash

# Check required environment variables are set
if [[ -z "$ACCOUNT_ID" ]]; then
    echo "Exiting, please set ACCOUNT_ID environment variable" 1>&2
    exit 1
fi

if [[ -z "$CLUSTER_NAME" ]]; then
    echo "Exiting, please set CLUSTER_NAME environment variable" 1>&2
    exit 1
fi

if [[ -z "$MESH_NAME" ]]; then
    echo "Exiting, please set MESH_NAME environment variable" 1>&2
    exit 1
fi

if [[ -z "$APPMESHED_K8S_NAMESPACE" ]]; then
    echo "Exiting, please set APPMESHED_K8S_NAMESPACE environment variable" 1>&2
    exit 1
fi

set -ex

# Download the IAM policy document for the Envoy proxies
curl -o envoy-iam-policy.json \
https://raw.githubusercontent.com/aws/aws-app-mesh-controller-for-k8s/master/config/iam/envoy-iam-policy.json

# Create an IAM policy for Envoy proxies from the IAM policy document
aws iam create-policy \
--policy-name AWSAppMeshEnvoySidecarIAMPolicy \
--policy-document file://envoy-iam-policy.json
echo "Created IAM policy for envoy sidecar permissions"

# Create K8s namespace
kubectl create ns $APPMESHED_K8S_NAMESPACE

# Create IRSA for default ServiceAccount
eksctl create iamserviceaccount \
--cluster $CLUSTER_NAME \
--namespace $APPMESHED_K8S_NAMESPACE \
--name default \
--attach-policy-arn arn:aws:iam::$ACCOUNT_ID:policy/AWSAppMeshEnvoySidecarIAMPolicy  \
--override-existing-serviceaccounts \
--approve
echo "Updated IAM role for default SA with envoy policy"

# Label the namespace
kubectl label namespace $APPMESHED_K8S_NAMESPACE mesh=$MESH_NAME
kubectl label namespace $APPMESHED_K8S_NAMESPACE appmesh.k8s.aws/sidecarInjectorWebhook=enabled