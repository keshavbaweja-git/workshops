### 1. Create Cloud9 IDE
### 2. Install tools
```
cd ~/environment
git clone https://github.com/keshavbaweja-git/workshops.git
cd workshops/aws-privatelink/bin
./install-tools.sh
```
### 3. Deploy ECS service
```
cd ~/environment/workshops/aws-privatelink/cdk-stack/my-service
cdk synth
cdk deploy
```
You will be prompted to proceed with stack deployment
![cdk deploy](.assets/cdk-deploy.png)
When complete, this stack would have deployed
- A VPC with public and private subnets with name starting with "MyServiceStack/" 
- An ECS Cluster with name starting with "MyServiceStack"
![cdk deploy](.assets/ecs-cluster.png)
- An ECS Service with name backed by two tasks "MyServiceStack-Service" with one task instance
![cdk deploy](.assets/ecs-cluster.png)
- A Private Network Load Balancer with name starting with "MySer-Servi"