### Start Zookeeper
cd $KAFKA_HOME
bin/zookeeper-server-start.sh config/zookeeper.properties > /dev/null 2>&1 &

### Start Kafka server
bin/kafka-server-start.sh config/server.properties > /dev/null 2>&1 &
