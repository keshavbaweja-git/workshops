### 1. Create Cloud9 IDE
### 2. Install tools
```
cd ~/environment
git clone 
cd workshops/aws-privatelink/bin
./install-tools.sh
```
### 3. Deploy ECS service
```
cd ~/environment/workshops/aws-privatelink/cdk-stack/my-service
cdk synth
cdk deploy
```