1. Create Topic
```
kafka-topics.sh --create --topic quickstart-events --bootstrap-server localhost:9092
```

2. Describe Topic
```
kafka-topics.sh --describe --topic quickstart-events --bootstrap-server localhost:9092
```

3. Publish messages
```
kafka-console-producer.sh --topic quickstart-events --bootstrap-server localhost:9092
```

4. Consume messages
```
kafka-console-consumer.sh --topic quickstart-events --from-beginning --bootstrap-server localhost:9092
```
