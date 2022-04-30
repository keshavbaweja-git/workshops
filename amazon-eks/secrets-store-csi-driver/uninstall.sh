#!/bin/bash

# https://secrets-store-csi-driver.sigs.k8s.io/getting-started/installation.html?search=ec
# https://github.com/aws/secrets-store-csi-driver-provider-aws

helm uninstall -n kube-system csi-secrets-store 
kubectl delete -f https://raw.githubusercontent.com/aws/secrets-store-csi-driver-provider-aws/main/deployment/aws-provider-installer.yaml


