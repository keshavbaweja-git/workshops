1. Install Java 17
```
sudo yum install java-17-amazon-corretto-devel
```

2. Install Apache Kafka
```
cd /home/ssm-user
wget -O kafka_2.13-3.1.0.tgz https://dlcdn.apache.org/kafka/3.1.0/kafka_2.13-3.1.0.tgz
tar -xzf kafka_2.13-3.1.0.tgz
rm kafka_2.13-3.1.0.tgz
echo 'export KAFKA_HOME=/home/ssm-user/kafka_2.13-3.1.0' >> ~/.bash_profile
echo 'PATH=$PATH:$KAFKA_HOME/bin' >> ~/.bash_profile
source ~/.bash_profile
```

3. Start Zookeeper
```
cd $KAFKA_HOME
bin/zookeeper-server-start.sh config/zookeeper.properties
```

4. Start Kafka server
```
bin/kafka-server-start.sh config/server.properties
```

5. Create Topic
```
bin/kafka-topics.sh --create --topic quickstart-events --bootstrap-server localhost:9092
```

6. Describe Topic
```
bin/kafka-topics.sh --describe --topic quickstart-events --bootstrap-server localhost:9092
```

7. Publish messages
```
bin/kafka-console-producer.sh --topic quickstart-events --bootstrap-server localhost:9092
```

8. Consume messages
```
bin/kafka-console-consumer.sh --topic quickstart-events --from-beginning --bootstrap-server localhost:9092
```
