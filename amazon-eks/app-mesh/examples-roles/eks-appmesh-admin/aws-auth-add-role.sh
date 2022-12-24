#!/bin/bash

aws-iam-authenticator add role \
--rolearn arn:aws:iam::646297494209:role/eks-appmesh-admin \
--username eks-appmesh-admin \
--groups pinnacle:eks-appmesh-admin \
--kubeconfig ~/.kube/config
