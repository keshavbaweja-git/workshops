#!/bin/bash

envsubst < eks-cluster-config.yaml | eksctl create cluster -f -
