#!/bin/bash

kubectl -n fp1 create deployment mynginx --image=nginx --replicas=1
kubectl -n fp1 expose deploy mynginx --port=80
