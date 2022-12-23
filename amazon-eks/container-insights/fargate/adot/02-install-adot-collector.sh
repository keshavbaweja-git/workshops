#!/bin/bash
CLUSTER_NAME=mycluster5
REGION=ap-southeast-1

curl https://raw.githubusercontent.com/aws-observability/aws-otel-collector/main/deployment-template/eks/otel-fargate-container-insights.yaml \
| sed 's/ClusterName=YOUR-EKS-CLUSTER-NAME/ClusterName='$CLUSTER_NAME'/' \
| sed 's/region: us-east-1/region: '$REGION'/' \
| kubectl apply -f -
