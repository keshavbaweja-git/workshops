### Create working directory
mkdir -p /home/ec2-user/kafka-certs
cd /home/ec2-user/kafka-certs


password=password
### Create CA certificate
echo 'Creating: CA certificate'
openssl req -new -x509 \
-keyout ca-key -out ca-cert \
-days 365 -passin pass:$password \
-subj "/C=SG/O=AWS/OU=SA/CN=ca"
echo 'Created: CA certificate'

### Create server truststore
echo 'Creating: server truststore'
keytool -keystore kafka.server.truststore.jks \
-alias CARoot -importcert -file ca-cert \
-storepass $password -noprompt
echo 'Created: server truststore'

### Create client truststore
echo 'Creating: client truststore'
keytool -keystore kafka.client.truststore.jks \
-alias CARoot -importcert -file ca-cert \
-storepass $password -noprompt
echo 'Created: client truststore'

hostname=$(hostname)
ext="SAN=DNS:${hostname}"
### Create server keystore
echo 'Creating: server keystore'
keytool -keystore kafka.server.keystore.jks \
-alias localhost -keyalg RSA \
-validity 365 -genkey \
-storepass $password -keypass $password \
-dname "CN=server01, OU=SA, O=AWS, L=Singapore, ST=Singapore, C=SG" \
-ext $ext
echo 'Created: server keystore'

echo 'Signing, adding: server cert to server keystore'
keytool -keystore kafka.server.keystore.jks \
-alias localhost -certreq -file cert-file \
-ext $ext \
-storepass $password

openssl x509 -req -CA ca-cert -CAkey ca-key \
-in cert-file -out cert-signed \
-days 365 -CAcreateserial -passin pass:$password

keytool -keystore kafka.server.keystore.jks \
-alias CARoot -importcert -file ca-cert \
-storepass $password -noprompt

keytool -keystore kafka.server.keystore.jks \
-alias localhost -importcert -file cert-signed \
-storepass $password -noprompt
echo 'Signed, added: server cert to server keystore'

### Create client keystore
echo 'Creating: client keystore'
keytool -keystore kafka.client.keystore.jks \
-alias localhost -keyalg RSA \
-validity 365 -genkey \
-storepass $password -keypass $password \
-dname "CN=client01, OU=SA, O=AWS, L=Singapore, ST=Singapore, C=SG"
echo 'Created: client keystore'

echo 'Signing, adding: client cert to client keystore'
keytool -keystore kafka.client.keystore.jks \
-alias localhost -certreq -file cert-file-client \
-storepass $password

openssl x509 -req -CA ca-cert -CAkey ca-key \
-in cert-file-client -out cert-signed-client \
-days 365 -CAcreateserial -passin pass:password

keytool -keystore kafka.client.keystore.jks \
-alias CARoot -importcert -file ca-cert \
-storepass $password -noprompt

keytool -keystore kafka.client.keystore.jks \
-alias localhost -importcert -file cert-signed-client \
-storepass $password -noprompt
echo 'Signed, added: client cert to client keystore'

