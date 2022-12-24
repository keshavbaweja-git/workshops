#!/bin/bash

aws-iam-authenticator add role \
--rolearn arn:aws:iam::646297494209:role/eks-appmesh-dev \
--username eks-appmesh-dev \
--groups pinnacle:eks-appmesh-dev \
--kubeconfig ~/.kube/config
