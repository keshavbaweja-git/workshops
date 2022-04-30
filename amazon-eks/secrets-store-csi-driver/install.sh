#!/bin/bash

# https://secrets-store-csi-driver.sigs.k8s.io/getting-started/installation.html?search=ec
# https://github.com/aws/secrets-store-csi-driver-provider-aws

helm repo add secrets-store-csi-driver https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts
helm install -n kube-system csi-secrets-store secrets-store-csi-driver/secrets-store-csi-driver
kubectl apply -f https://raw.githubusercontent.com/aws/secrets-store-csi-driver-provider-aws/main/deployment/aws-provider-installer.yaml


