#!/bin/bash
eksctl utils associate-iam-oidc-provider --region=${AWS_REGION} --cluster=mycluster1 --approve
envsubst < eks-cluster-config.yaml | eksctl create addon -f -