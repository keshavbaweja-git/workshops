#!/bin/bash

aws iam create-policy \
--policy-name AmazonEKSClusterAutoscalerPolicy \
--policy-document file://cluster-autoscaler-policy.json

CLUSTER_AUTOSCALER_SA_NAME=cluster-autoscaler
eksctl create iamserviceaccount \
--cluster=$CLUSTER_NAME \
--namespace=kube-system \
--name=$CLUSTER_AUTOSCALER_SA_NAME \
--attach-policy-arn=arn:aws:iam::$ACCOUNT_ID:policy/AmazonEKSClusterAutoscalerPolicy \
--override-existing-serviceaccounts \
--approve 

CLUSTER_AUTOSCALER_ROLE_ARN=$(eksctl get iamserviceaccount --cluster=$CLUSTER_NAME --namespace=kube-system --name=$CLUSTER_AUTOSCALER_SA_NAME -o=json -v=0 | jq -r '.[0].status.roleARN')
curl -o cluster-autoscaler-autodiscover.yaml https://raw.githubusercontent.com/kubernetes/autoscaler/master/cluster-autoscaler/cloudprovider/aws/examples/cluster-autoscaler-autodiscover.yaml
sed -i "s/<YOUR CLUSTER NAME>/$CLUSTER_NAME/g" cluster-autoscaler-autodiscover.yaml
kubectl apply -f cluster-autoscaler-autodiscover.yaml

kubectl patch deployment cluster-autoscaler \
-n kube-system \
-p '{"spec":{"template":{"metadata":{"annotations":{"cluster-autoscaler.kubernetes.io/safe-to-evict": "false"}}}}}'
