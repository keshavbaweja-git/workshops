#!/bin/bash
CLUSTER_NAME=mycluster5
REGION=ap-southeast-1
POLICY_ARN=arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy

k create ns fargate-container-insights

eksctl create iamserviceaccount \
--name adot-collector \
--namespace fargate-container-insights \
--region $REGION \
--cluster $CLUSTER_NAME \
--attach-policy-arn "$POLICY_ARN" \
--approve \
--override-existing-serviceaccounts

