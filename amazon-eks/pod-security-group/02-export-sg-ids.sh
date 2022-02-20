#!/bin/bash

export NGINX_POD_SG_ID=$(aws ec2 describe-security-groups \
--filters Name=group-name,Values=NGINX_POD_SG Name=vpc-id,Values=${VPC_ID} \
--query "SecurityGroups[0].GroupId" --output text)
echo "NGINX_POD_SG_ID: ${NGINX_POD_SG_ID}"

export BUSYBOX_POD_SG_ID=$(aws ec2 describe-security-groups \
--filters Name=group-name,Values=BUSYBOX_POD_SG Name=vpc-id,Values=${VPC_ID} \
--query "SecurityGroups[0].GroupId" --output text)
echo "BUSYBOX_POD_SG_ID: ${BUSYBOX_POD_SG_ID}"

export NODE_GROUP_SG_ID=$(aws ec2 describe-security-groups \
--filters Name=tag:Name,Values=eksctl-${CLUSTER_NAME}-* Name=vpc-id,Values=${VPC_ID} \
--query "SecurityGroups[0].GroupId" \
--output text)
echo "NODE_GROUP_SG_ID: ${NODE_GROUP_SG_ID}"

export CLUSTER_SG_ID=$(aws ec2 describe-security-groups \
--filters Name=tag:Name,Values=eks-cluster-*-${CLUSTER_NAME}-* Name=vpc-id,Values=${VPC_ID} \
--query "SecurityGroups[0].GroupId" \
--output text)
echo "CLUSTER_SG_ID: ${CLUSTER_SG_ID}"