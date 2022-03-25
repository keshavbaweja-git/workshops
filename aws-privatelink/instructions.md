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
![ECS Cluster](.assets/ecs-cluster.png)
- An ECS Service with name starting with "MyServiceStack-Service" with one task instance
![ECS Service](.assets/ecs-cluster.png)
- A Private Network Load Balancer with name starting with "MySer-Servi"
![Private NLB](.assets/private-nlb.png)

### 4. Configure ECS service security group
The ECS service created by the CDK stack has a security group associated with it. At this moment, this security group does not allow inbound traffic from private NLB provisioned. Due to this the health checks for NLB are failing and the ECS task is being recreated repeatedly. Let's correct this by updating the ECS service security group.

- Determine the internal IP addresses assigned to private NLB
```
aws ec2 describe-network-interfaces \
--filters Name=description,Values="ELB net/<load-balancer-name>/<load-balancer-id>" \
--query 'NetworkInterfaces[*].PrivateIpAddresses[*].PrivateIpAddress' \
--output text
```
![Private NLB Internal IPs](.assets/private-nlb-internal-ips.png)

- Now we add two inbound rules to the security group associated with the ECS service to allow traffic from private NLB internal IP addresses.
![ECS Service Security Group inbound rules](.assets/ecs-service-security-group-inbound-rules.png)

- Once done, the Load Balance Target Group will show up as healthy.
![Target Group](.assets/target-group.png)

### 5. Test private NLB access
Let's try to access the ECS service from the NLB private DNS name. This will not work as the Cloud9 IDE is hosted in a different VPC with no route to the private NLB in the VPC created by our CDK stack.
![NLB Failure](.assets/nlb-failure.png)

### 6. Create VPC Endpoint Service
![Endpoint service](.assets/endpoint-service.png)
![Allow principals](.assets/allow-principals.png)

### 7. Create VPC Endpoint
Now let's create a VPC endpoint in default VPC. Select "Other endpoint services" in the Service category and specify the endpoint service name created in step 6. You can verify the service name to ensure it is correct. Then specify the default VPC and subnets where Elastic Network Interfaces (ENIs) for the endpoint will be placed. Select default security group to be associated with the endpoint ENIs.
![Endpoint](.assets/create-endpoint-1.png)
![Endpoint](.assets/create-endpoint-2.png)

### 8. Accept VPC Endpoint connection
Once a VPC Endpoint connection request has been submitted, an approval will show up for the VPC Endpoint Service. Let's approve the VPC Endpoint connection request.
![Endpoint](.assets/accept-connection-1.png)
![Endpoint](.assets/accept-connection-2.png)

### 9. Update security group for VPC endpoint

### 10. Test service access via VPC endpoint
Let's now try accessing the service via the endpoint created.
![Access service](.assets/test-service-endpoint.png)