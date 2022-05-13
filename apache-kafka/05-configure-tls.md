1. Update server properties
```
# Add following lines to $KAFKA_HOME/config/server.properties
listeners=PLAINTEXT://localhost:9092,SSL://localhost:9093
advertised.listeners=PLAINTEXT://localhost:9092,SSL://localhost:9093
ssl.truststore.location=/home/ec2-user/kafka-certs/kafka.server.truststore.jks
ssl.truststore.password=password
ssl.keystore.location=/home/ec2-user/kafka-certs/kafka.server.keystore.jks
ssl.keystore.password=password
ssl.key.password=password
```

2. Create client properties
```
### Add following lines to /home/ec2-user/kafka-certs/client-ssl.properties
bootstrap.servers=localhost:9093
security.protocol=SSL
ssl.endpoint.identification.algorithm=
ssl.truststore.location=/home/ec2-user/kafka-certs/kafka.client.truststore.jks
ssl.truststore.password=password
ssl.keystore.location=/home/ec2-user/kafka-certs/kafka.client.keystore.jks
ssl.keystore.password=password
ssl.key.password=password
```

3. Restart Kafka server

4. Consume messages using SSL
```
$KAFKA_HOME/bin/kafka-console-consumer.sh --bootstrap-server localhost:9093 --topic quickstart-events --consumer.config /home/ec2-user/kafka-certs/client-ssl.properties --from-beginning
```
