import { CfnOutput, Duration, Stack, StackProps } from "aws-cdk-lib";
import { Vpc } from "aws-cdk-lib/aws-ec2";
import * as ecs from "aws-cdk-lib/aws-ecs";
import { ContainerImage } from "aws-cdk-lib/aws-ecs";
import {
  DnsRecordType,
  PrivateDnsNamespace,
  Service,
} from "aws-cdk-lib/aws-servicediscovery";
import { Construct } from "constructs";

export class EcsServicediscoveryStack extends Stack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props);

    const vpc = Vpc.fromLookup(this, "Vpc", {
      vpcName: "mycluster2/mycluster2-vpc",
    });

    const privateDnsNamespace = new PrivateDnsNamespace(
      this,
      "SummitNamespace",
      {
        name: "Summit",
        vpc: vpc,
      }
    );

    const serviceDiscoveryService = new Service(this, "SummitService", {
      namespace: privateDnsNamespace,
      name: "SummitServiceDiscoveryService",
      dnsRecordType: DnsRecordType.A,
      dnsTtl: Duration.seconds(60),
      customHealthCheck: { failureThreshold: 1 },
    });

    const cluster = new ecs.Cluster(this, "Cluster", {
      vpc: vpc,
      clusterName: "ClusterWithServiceDiscovery",
    });

    const fargateTaskDefinition = new ecs.FargateTaskDefinition(
      this,
      "FargateTaskDefinition",
      {
        memoryLimitMiB: 512,
        cpu: 256,
      }
    );

    new ecs.ContainerDefinition(this, "ContainerDefinition", {
      containerName: "SimpleWebApp",
      image: ContainerImage.fromRegistry("httpd:2.4"),
      portMappings: [{ containerPort: 80 }],
      taskDefinition: fargateTaskDefinition,
      essential: true,
      entryPoint: ["sh", "-c"],
      command: [
        "echo '<html><head><title>Amazon ECS Sample App</title><style>body {margin-top: 40px; background-color: #333;} </style> </head><body> <div style=color:white;text-align:center> <h1>Amazon ECS Sample App</h1> <h2>Congratulations!</h2> <p>Your application is now running on a container in Amazon ECS.</p> </div></body></html>' >  /usr/local/apache2/htdocs/index.html && httpd-foreground",
      ],
    });

    const fargateService = new ecs.FargateService(this, "FargateService", {
      serviceName: "WepAppService",
      cluster: cluster,
      taskDefinition: fargateTaskDefinition,
      desiredCount: 3,
    });

    fargateService.associateCloudMapService({
      service: serviceDiscoveryService,
    });

    new CfnOutput(this, "FargateServiceArn", {
      exportName: "FargateServiceArn",
      value: fargateService.serviceArn,
    });
  }
}
