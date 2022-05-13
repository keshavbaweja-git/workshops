### Create working directory
mkdir -p /home/ec2-user/kafka-certs
cd /home/ec2-user/kafka-certs


### Create CA certificate
openssl req -new -x509 -keyout ca-key -out ca-cert -days 365

### Create server truststore
keytool -keystore kafka.server.truststore.jks -alias CARoot -importcert -file ca-cert

### Create client truststore
keytool -keystore kafka.client.truststore.jks -alias CARoot -importcert -file ca-cert

### Create server keystore
keytool -keystore kafka.server.keystore.jks -alias localhost -keyalg RSA -genkey
keytool -keystore kafka.server.keystore.jks -alias localhost -certreq -file cert-file
openssl x509 -req -CA ca-cert -CAkey ca-key -in cert-file -out cert-signed -days 365 -CAcreateserial -passin pass:password
keytool -keystore kafka.server.keystore.jks -alias CARoot -importcert -file ca-cert
keytool -keystore kafka.server.keystore.jks -alias localhost -importcert -file cert-signed

### Create client keystore
keytool -keystore kafka.client.keystore.jks -alias localhost -keyalg RSA -genkey
keytool -keystore kafka.client.keystore.jks -alias localhost -certreq -file cert-file-client
openssl x509 -req -CA ca-cert -CAkey ca-key -in cert-file-client -out cert-signed-client -days 365 -CAcreateserial -passin pass:password
keytool -keystore kafka.client.keystore.jks -alias CARoot -importcert -file ca-cert
keytool -keystore kafka.client.keystore.jks -alias localhost -importcert -file cert-signed-client

