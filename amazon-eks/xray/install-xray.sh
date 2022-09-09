#!/bin/bash

ClusterName=mycluster3

eksctl create iamserviceaccount \
--name xray-daemon \
--namespace default \
--cluster $ClusterName \
--attach-policy-arn arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess \
--approve --override-existing-serviceaccounts

kubectl label serviceaccount xray-daemon app=xray-daemon

kubectl create -f https://eksworkshop.com/intermediate/245_x-ray/daemonset.files/xray-k8s-daemonset.yaml
