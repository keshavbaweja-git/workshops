# Prerequisites
## 0. Create AWS CloudFormation Stack
[CloudFormation template](https://aws-streaming-artifacts.s3.amazonaws.com/msk-lab-resources/MSKLabs/MSKBastionKafkaClientCluster.yml)

## 1. Check AWS CLI version
```
aws --version
```

## 2. Uninstall AWS CLI v1
```
pip uninstall awscli
```

## 3. Add AWS CLI v2 to PATH
```
export PATH=$PATH:/usr/local/aws-cli/v2/current/bin
```

## 4. Add Kafka binaries to PATH
```
export PATH=$PATH:/home/ec2-user/kafka/bin
```


# Cluster environment variables
## 5. Export Amazon MSK Cluster ARN
```
# List Cluster ARN and name
aws kafka list-clusters | jq '[.ClusterInfoList[] | {ClusterArn, ClusterName}]'

# Export Cluster ARN
export CLUSTER_ARN=$(aws kafka list-clusters | jq -r '.ClusterInfoList[] | select(.ClusterName == "MSKWorkshopCluster") | .ClusterArn')
```

## 6. View Amazon MSK Cluster Information
```
aws kafka describe-cluster --cluster-arn $CLUSTER_ARN | jq '.'
```

## 7. Export Kafka brokers
```
export MY_BROKERS=$(aws kafka  get-bootstrap-brokers --cluster-arn $CLUSTER_ARN | jq -r '.BootstrapBrokerString')

export MY_BROKERS_TLS=$(aws kafka  get-bootstrap-brokers --cluster-arn $CLUSTER_ARN | jq -r '.BootstrapBrokerStringTls')
```

## 8. Export Zookeeper servers
```
export MY_ZK=$(aws kafka describe-cluster --cluster-arn $CLUSTER_ARN | jq -r '.ClusterInfo.ZookeeperConnectString')
```

# Topic management
## 9. Create topic
```
kafka-topics.sh \
--zookeeper $MY_ZK \
--create \
--topic ExampleTopic10 \
--partitions 10 \
--replication-factor 3

kafka-topics.sh \
--zookeeper $MY_ZK \
--create \
--topic TestAclFail \
--partitions 10 \
--replication-factor 3
```

## 10. Describe topic
```
kafka-topics.sh --zookeeper $MY_ZK --describe
kafka-topics.sh --zookeeper $MY_ZK --describe --topic ExampleTopic10
```

## 11. Start Kafka console producer
```
kafka-console-producer.sh --broker-list $MY_BROKERS --topic ExampleTopic10
```

## 12. Start Kafka console consumer
```
kafka-console-consumer.sh --bootstrap-server $MY_BROKERS --topic ExampleTopic10 --from-beginning
```

## 13. Delete topic
```
kafka-topics.sh --zookeeper $MY_ZK --delete --topic ExampleTopic10
```

# Partition Reassignment
## 14. Reassign partitions
``` 
# Create a file topics-to-move.json
cat > topics-to-move.json <<EOF
{ "topics": [ { "topic" : "ExampleTopic10"}], "version":1}
EOF

kafka-reassign-partitions.sh --zookeeper $MY_ZK \
--topics-to-move-json-file topics-to-move.json \
--broker-list "1,2,3,4,5,6" --generate

# Create a file expand-cluster-reassignment.json with contents of proposed partition reassignment configuration

kafka-reassign-partitions.sh --zookeeper $MY_ZK \
--reassignment-json-file expand-cluster-reassignment.json \
--execute

kafka-reassign-partitions.sh --zookeeper $MY_ZK \
--reassignment-json-file expand-cluster-reassignment.json \
--verify
```

# Monitoring - Prometheus
## 15. Run Prometheus in a Docker container
Create Prometheus configuration file and targets file as per instructions [here](https://catalog.us-east-1.prod.workshops.aws/v2/workshops/5e7795af-4545-4711-9c19-b85bfd6455a9/en-US/openmonitoring/installwithdocker)
```
sudo docker run -d -p 9090:9090 \
--name=prometheus \
-v /home/ec2-user/environment/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml \
-v /home/ec2-user/environment/prometheus/targets.json:/etc/prometheus/targets.json prom/prometheus \
--config.file=/etc/prometheus/prometheus.yml
```

## 16. Run Grafana in a Docker container
```
docker run -d -p 3000:3000 \
--name=grafana -e "GF_INSTALL_PLUGINS=grafana-clock-panel" \
grafana/grafana
```
# TLS communication
## 17. Create client truststore
```
mkdir /tmp/tls

cp /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.312.b07-1.amzn2.0.2.x86_64/jre/lib/security/cacerts \
/tmp/tls/kafka.client.truststore.jks
```

## 18. Create client keystore
```
cd /tmp/tls

keytool -genkey \
-keystore kafka.client.keystore.jks \
-validity 300 \
-storepass password \
-keypass password \
-dname "CN=msk-client" \
-alias msk-client \
-storetype pkcs12
```

## 19. Generate client CSR
```
keytool -certreq \
-keystore kafka.client.keystore.jks \
-file client-cert-sign-request \
-alias msk-client \
-storepass password \
-keypass password

sed -i \
's/NEW //' \
client-cert-sign-request
```

## 20. Issue client certificate
```
aws acm-pca list-certificate-authorities

export CA_ARN=<private-ca-arn>

aws acm-pca issue-certificate \
--certificate-authority-arn $CA_ARN \
--csr fileb://client-cert-sign-request \
--signing-algorithm "SHA256WITHRSA" \
--validity Value=300,Type="DAYS"

export CERTIFICATE_ARN=<certificate-arn>
```

## 21. Get client certificate
```
aws acm-pca get-certificate \
--certificate-authority-arn $CA_ARN \
--certificate-arn $CERTIFICATE_ARN \
| jq -r '.Certificate' > signed-certificate-from-acm

aws acm-pca get-certificate \
--certificate-authority-arn $CA_ARN \
--certificate-arn $CERTIFICATE_ARN \
| jq -r '.CertificateChain' >> signed-certificate-from-acm
```

## 22. Import client certificate
```
keytool -import \
-keystore kafka.client.keystore.jks \
-file signed-certificate-from-acm \
-alias msk-client \
-storepass password \
-keypass password

keytool -list -v -keystore kafka.client.keystore.jks
```

## 23. Create Kafka client properties file
```
cat > /tmp/tls/client.properties <<EOF
security.protocol=SSL
ssl.truststore.location=/tmp/tls/kafka.client.truststore.jks
ssl.keystore.location=/tmp/tls/kafka.client.keystore.jks
ssl.keystore.password=password
ssl.key.password=password
EOF
```

## 24. Start Kafka console producer with TLS
```
kafka-console-producer.sh \
--broker-list $MY_BROKERS_TLS \
--topic ExampleTopic10 \
--producer.config /tmp/tls/client.properties
```

## 25. Start Kafka console consumer with TLS
```
kafka-console-consumer.sh \
--bootstrap-server $MY_BROKERS_TLS \
--topic ExampleTopic10 \
--from-beginning \
--consumer.config /tmp/tls/client.properties
```

# Topic Authorization
## 26. Setup topic authorization
```
kafka-acls.sh \
--add \
--authorizer-properties \
zookeeper.connect=$MY_ZK \
--allow-principal User:CN=msk-client \
--operation Read \
--operation Write \
--topic ExampleTopic10

kafka-acls.sh \
--list \
--authorizer-properties \
zookeeper.connect=$MY_ZK \
--topic ExampleTopic10

kafka-acls.sh \
--remove \
--authorizer-properties \
zookeeper.connect=$MY_ZK \
--topic ExampleTopic10
```
# Public access
## 27. Public access with AWS IAM
Set up an Amazon MSK cluster with AWS IAM authentication mechanism. Please ensure all requirements for public access as documented [here](https://docs.aws.amazon.com/msk/latest/developerguide/public-access.html) are met.
```
# Option 1: Specify AWS Access Key and AWS Secret Key as environment variables
docker run -p 8080:8080 \
-e KAFKA_CLUSTERS_0_NAME=msk-cluster \
-e KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS=<public-endpoints-iam-authentication-bootstrap-servers> \
-e KAFKA_CLUSTERS_0_PROPERTIES_SECURITY_PROTOCOL=SASL_SSL \
-e KAFKA_CLUSTERS_0_PROPERTIES_SASL_MECHANISM=AWS_MSK_IAM \
-e KAFKA_CLUSTERS_0_PROPERTIES_SASL_CLIENT_CALLBACK_HANDLER_CLASS=software.amazon.msk.auth.iam.IAMClientCallbackHandler \
-e KAFKA_CLUSTERS_0_PROPERTIES_SASL_JAAS_CONFIG='software.amazon.msk.auth.iam.IAMLoginModule required awsProfileName="default";' \
-e AWS_ACCESS_KEY=<aws-access-key> \
-e AWS_SECRET_KEY=<aws-secret-key> \
-d provectuslabs/kafka-ui:latest

# Option 2: Mount the folder holding AWS credentials
docker run -p 8080:8080 \
-e KAFKA_CLUSTERS_0_NAME=msk-cluster \
-e KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS=<public-endpoints-iam-authentication-bootstrap-servers> \
-e KAFKA_CLUSTERS_0_PROPERTIES_SECURITY_PROTOCOL=SASL_SSL \
-e KAFKA_CLUSTERS_0_PROPERTIES_SASL_MECHANISM=AWS_MSK_IAM \
-e KAFKA_CLUSTERS_0_PROPERTIES_SASL_CLIENT_CALLBACK_HANDLER_CLASS=software.amazon.msk.auth.iam.IAMClientCallbackHandler \
-e KAFKA_CLUSTERS_0_PROPERTIES_SASL_JAAS_CONFIG='software.amazon.msk.auth.iam.IAMLoginModule required awsProfileName="default";' \
-v <path-to-aws-credentials-folder>:/root/.aws \
-d provectuslabs/kafka-ui:latest
```

# Appendix
## Install AWS CLI v2
```
cd /tmp
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
export PATH=$PATH:/usr/local/aws-cli/v2/current/bin
```

## Install jq
```
cd /tmp
wget https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64
chmod +x jq-linux64
mkdir /home/ec2-user/bin
mv jq-linux64 /home/ec2-user/bin/jq
```

