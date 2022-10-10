## 1. Install Confluent platform
```
curl -O http://packages.confluent.io/archive/7.2/confluent-community-7.2.2.tar.gz
tar -xzf confluent-community-7.2.2.tar.gz
rm confluent-community-7.2.2.tar.gz
```

## 2. Add AWS MSK IAM library to Kafka Rest proxy classpath
```
cd confluent-community-7.2.2
wget https://github.com/aws/aws-msk-iam-auth/releases/download/v1.1.4/aws-msk-iam-auth-1.1.4-all.jar
mv aws-msk-iam-auth-1.1.4-all.jar confluent-7.2.2/share/java/kafka-rest-lib/
```
## 3. Update kafka-rest.properties
etc/kafka-rest/kafka-rest.properties
```
schema.registry.url=
bootstrap.servers=<aws-msk-cluster-bootstrap-servers>
client.security.protocol=SASL_SSL
client.sasl.mechanism=AWS_MSK_IAM
client.sasl.jaas.config=software.amazon.msk.auth.iam.IAMLoginModule required awsDebugCreds=true;
client.sasl.client.callback.handler.class=software.amazon.msk.auth.iam.IAMClientCallbackHandler
```

## 4. Start Kafka Rest proxy
```
bin/kafka-rest-start ./etc/kafka-rest/kafka-rest.properties
```

## 5. Publish message
```
curl -X POST -H "Content-Type: application/vnd.kafka.json.v2+json" \
--data '{"records":[{"value":{"foo":"bar"}}]}' "http://localhost:8082/topics/product"
```

## 6. Create consumer subscription
```
curl -X POST -H "Content-Type: application/vnd.kafka.v2+json" \
--data '{"name": "my_consumer_instance", "format": "json", "auto.offset.reset": "earliest"}' \
http://localhost:8082/consumers/my_json_consumer

curl -X POST -H "Content-Type: application/vnd.kafka.v2+json" --data '{"topics":["product"]}' \
http://localhost:8082/consumers/my_json_consumer/instances/my_consumer_instance/subscription
```

## 7. Consume message
```
curl -X GET -H "Accept: application/vnd.kafka.json.v2+json" \
http://localhost:8082/consumers/my_json_consumer/instances/my_consumer_instance/records
```