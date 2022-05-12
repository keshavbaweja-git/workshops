1. Deploy CDK stack to create a Cognito UserPool
```
cd cognito-user-pool
cdk synth
cdk deploy
```

2. Set UserPool attribute values from CDK stack output as environment variables
```
export CLIENT_ID=<clinet-id>
export ISSUER_URL=<issuer-url>
export POOL_ID=<pool-id>
```

3. Create user and user-group in UserPool
```
aws cognito-idp admin-create-user --user-pool-id $POOL_ID --username test@example.com --temporary-password password
 
aws cognito-idp admin-set-user-password --user-pool-id $POOL_ID --username test@example.com --password Blah123$ --permanent
 
aws cognito-idp create-group --group-name secret-reader --user-pool-id $POOL_ID 
 
aws cognito-idp admin-add-user-to-group --user-pool-id $POOL_ID --username test@example.com --group-name secret-reader
```

4. Print ID Token
```
aws cognito-idp admin-initiate-auth --auth-flow ADMIN_USER_PASSWORD_AUTH \
--client-id $CLIENT_ID \
--auth-parameters USERNAME=test@example.com,PASSWORD=Blah123$ \
--user-pool-id $POOL_ID --query 'AuthenticationResult.IdToken' \
--output text
```

5. You can decode and view JWT contents online at https://jwt.io/

6. Associated Cognito UserPool as OIDC provide with the EKS cluster
```
aws eks associate-identity-provider-config \
--cluster-name mycluster2 \
--oidc identityProviderConfigName=<config-name>,issuerUrl=<ISSUER_URL>,clientId=<CLIENT_ID>,usernameClaim=email,groupsClaim=cognito:groups,groupsPrefix=gid:
```

7. Create k8s ClusterRole and ClusterRoleBinding for OIDC user-group
```
k create clusterrole read-secrets --verb=get,list,watch --resource=secrets
k create clusterrolebinding read-secrets-role-binding --clusterrole=read-secrets --group=gid:secret-reader
```

8. Get OIDC Refresh and ID tokens for the user
```
aws cognito-idp admin-initiate-auth --auth-flow ADMIN_USER_PASSWORD_AUTH \
--client-id $CLIENT_ID \
--auth-parameters USERNAME=test@example.com,PASSWORD=Blah123$ \
--user-pool-id $POOL_ID \
--query 'AuthenticationResult.[RefreshToken, IdToken]'
```

9. Test access to k8s cluster with ID Token
```
k -n kube-system --token=<id-token> get secrets ### Should execute successfully
k -n kube-system --token=<id-token> get nodes ### Should fail
```

10. Alternatively, if you don't want to specify ID token on command line, add kubectl user configured with OIDC authenticated token 
```
kubectl config set-credentials cognito-user \
--auth-provider=oidc \
--auth-provider-arg=idp-issuer-url=$ISSUER_URL \
--auth-provider-arg=client-id=$CLIENT_ID \
--auth-provider-arg=refresh-token=<refresh_token> \
--auth-provider-arg=id-token=<id_token>
```

11. Add kubectl context for OIDC authenticated user
```
k config set-context oidc-secret-reader --cluster="<cluster-arn>" --user=cognito-user
k config use-context oidc-secret-reader
```

12. Test access to k8s cluster configured kubectl context
```
k -n kube-system --token=<id-token> get secrets ### Should execute successfully
k -n kube-system --token=<id-token> get nodes ### Should fail
```
