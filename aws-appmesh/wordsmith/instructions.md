1. Create namespace
```
k create ns wordsmith
```

2. Deploy wordsmith application
```
k apply -f k8s-templates/kube-deployment.yaml
```

3. Get the load balance DNS name
```
k -n wordsmith get svc web
``` 

4. Launch the application in browser at port 8081 on the DNS name from above.

5. Create IAM policy for envoy proxy
```
curl -o envoy-iam-policy.json https://raw.githubusercontent.com/aws/aws-app-mesh-controller-for-k8s/master/config/iam/envoy-iam-policy.json

aws iam create-policy \
--policy-name AWSAppMeshEnvoySidecarIAMPolicy \
--policy-document file://envoy-iam-policy.json
echo "Created IAM policy for envoy sidecar permissions"
```

6. Create IAM role for envoy proxy and associate it with k8s service account.
```
eksctl create iamserviceaccount \
--cluster $CLUSTER_NAME \
--namespace wordsmith \
--name default \
--attach-policy-arn arn:aws:iam::$ACCOUNT_ID:policy/AWSAppMeshEnvoySidecarIAMPolicy  \
--override-existing-serviceaccounts \
--approve
echo "Updated IAM role for default SA with envoy policy"
```

7. Label the namespace
```
k label namespace wordsmith mesh=wordsmith
k label namespace wordsmith appmesh.k8s.aws/sidecarInjectorWebhook=enabled
```

8. Create AWS App Mesh resources
```
k apply -f appmesh-k8s-templates/mesh.yaml
k apply -f appmesh-k8s-templates/db.yaml
k apply -f appmesh-k8s-templates/web.yaml
k apply -f appmesh-k8s-templates/words.yaml
```

9. Recreate all pods
```
k -n wordsmith delete pods --all
```

10. Test the meshified application in browser