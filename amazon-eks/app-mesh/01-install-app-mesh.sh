#!/bin/bash

# Check required environment variables are set
if [[ -z "$CLUSTER_NAME" ]]; then
    echo "Exiting, please set CLUSTER_NAME environment variable" 1>&2
    exit 1
fi

if [[ -z "$AWS_REGION" ]]; then
    echo "Exiting, please set AWS_REGION environment variable" 1>&2
    exit 1
fi

set -ex

# Install App Mesh CRDs
kubectl apply -k "https://github.com/aws/eks-charts/stable/appmesh-controller/crds?ref=master"
echo "Installed appmesh-controller CRDs"

# List api-resources for App Mesh
kubectl api-resources --api-group=appmesh.k8s.aws

# Create App Mesh namespace
kubectl create ns appmesh-system
echo "Created namespace for appmesh-controller"

# Create App Mesh IRSA (IAM role for ServiceAccount)
eksctl create iamserviceaccount \
--cluster $CLUSTER_NAME \
--namespace appmesh-system \
--name appmesh-controller \
--attach-policy-arn  arn:aws:iam::aws:policy/AWSCloudMapFullAccess,arn:aws:iam::aws:policy/AWSAppMeshFullAccess \
--override-existing-serviceaccounts \
--approve
echo "Created serviceAccount with IAM role for appmesh-controller"

# Install App Mesh contoller
helm repo add eks https://aws.github.io/eks-charts

helm upgrade -i appmesh-controller eks/appmesh-controller \
--namespace appmesh-system \
--set region=$AWS_REGION \
--set serviceAccount.create=false \
--set serviceAccount.name=appmesh-controller
echo "Installed appmesh-controller"
