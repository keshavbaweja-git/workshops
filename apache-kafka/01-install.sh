### Install Java 17
sudo yum install java-17-amazon-corretto-devel

### Install Apache Kafka
cd /home/ec2-user
wget -O kafka_2.13-3.1.0.tgz https://dlcdn.apache.org/kafka/3.1.0/kafka_2.13-3.1.0.tgz
tar -xzf kafka_2.13-3.1.0.tgz
rm kafka_2.13-3.1.0.tgz
echo 'export KAFKA_HOME=/home/ec2-user/kafka_2.13-3.1.0' >> ~/.bash_profile
echo 'PATH=$PATH:$KAFKA_HOME/bin' >> ~/.bash_profile
source ~/.bash_profile
