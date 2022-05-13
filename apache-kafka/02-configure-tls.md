1. Create working directory
```
mkdir -p /home/ssm-user/kafka-certs
cd /home/ssm-user/kafka-certs
```

1. Create CA certificate
```
openssl req -new -x509 -keyout ca-key -out ca-cert -days 365
```

2. Create server truststore
```
keytool -keystore kafka.server.truststore.jks -alias CARoot -importcert -file ca-cert
```

3. Create client truststore
```
keytool -keystore kafka.client.truststore.jks -alias CARoot -importcert -file ca-cert
```

4. Create server keystore
```
keytool -keystore kafka.server.keystore.jks -alias localhost -keyalg RSA -genkey
keytool -keystore kafka.server.keystore.jks -alias localhost -certreq -file cert-file
openssl x509 -req -CA ca-cert -CAkey ca-key -in cert-file -out cert-signed -days 365 -CAcreateserial -passin pass:password
keytool -keystore kafka.server.keystore.jks -alias CARoot -importcert -file ca-cert
keytool -keystore kafka.server.keystore.jks -alias localhost -importcert -file cert-signed
```

5. Create client keystore
```
keytool -keystore kafka.client.keystore.jks -alias localhost -keyalg RSA -genkey
keytool -keystore kafka.client.keystore.jks -alias localhost -certreq -file cert-file-client
openssl x509 -req -CA ca-cert -CAkey ca-key -in cert-file-client -out cert-signed-client -days 365 -CAcreateserial -passin pass:password
keytool -keystore kafka.client.keystore.jks -alias CARoot -importcert -file ca-cert
keytool -keystore kafka.client.keystore.jks -alias localhost -importcert -file cert-signed-client
```

6. Update server properties
```
# Add following lines to $KAFKA_HOME/config/server.properties
ssl.truststore.location=/home/ssm-user/kafka-certs/kafka.server.truststore.jks
ssl.truststore.password=password
ssl.keystore.location=/home/ssm-user/kafka-certs/kafka.server.keystore.jks
ssl.keystore.password=password
ssl.key.password=password
```

7. Create client properties
```
### Add following lines to /home/ssm-user/kafka-certs/client-ssl.properties
bootstrap.servers=localhost:9093
security.protocol=SSL
ssl.endpoint.identification.algorithm=
ssl.truststore.location=/home/ssm-user/kafka-certs/kafka.client.truststore.jks
ssl.truststore.password=password
ssl.keystore.location=/home/ssm-user/kafka-certs/kafka.client.keystore.jks
ssl.keystore.password=password
ssl.key.password=password
```

8. Restart Kafka server

9. Consume messages using SSL
```
$KAFKA_HOME/bin/kafka-console-consumer.sh --bootstrap-server localhost:9093 --topic quickstart-events --consumer.config /home/ssm-user/kafka-certs/client-ssl.properties --from-beginning
```
