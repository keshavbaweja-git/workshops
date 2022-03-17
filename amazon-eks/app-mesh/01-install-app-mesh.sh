#!/bin/bash

helm repo add eks https://aws.github.io/eks-charts

kubectl apply -k "https://github.com/aws/eks-charts/stable/appmesh-controller/crds?ref=master"
echo "Installed appmesh-controller CRDs"

kubectl create ns appmesh-system
echo "Created namespace for appmesh-controller"

eksctl create iamserviceaccount \
--cluster $CLUSTER_NAME \
--namespace appmesh-system \
--name appmesh-controller \
--attach-policy-arn  arn:aws:iam::aws:policy/AWSCloudMapFullAccess,arn:aws:iam::aws:policy/AWSAppMeshFullAccess \
--override-existing-serviceaccounts \
--approve
echo "Created serviceAccount with IAM role for appmesh-controller"

helm upgrade -i appmesh-controller eks/appmesh-controller \
--namespace appmesh-system \
--set region=$AWS_REGION \
--set serviceAccount.create=false \
--set serviceAccount.name=appmesh-controller
echo "Installed appmesh-controller"
