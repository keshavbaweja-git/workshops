k run my-tomcat --image=tomcat:8.5-jdk8-corretto --expose --port=8080

k create secret generic my-secret --from-literal=key1=supersecret2 --from-literal=key2=topsecret2

k get secret my-secret -o json | jq -r .data.key1 | base64 -d
k exec -ti my-tomcat-6455f5c94c-52bjg -- cat /var/run/secrets/my-tomcat/key1
