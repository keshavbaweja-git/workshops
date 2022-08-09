import { Fn, Stack, StackProps } from "aws-cdk-lib";
import { Vpc } from "aws-cdk-lib/aws-ec2";
import * as ecs from "aws-cdk-lib/aws-ecs";
import { ContainerImage } from "aws-cdk-lib/aws-ecs";
import * as ecsPatterns from "aws-cdk-lib/aws-ecs-patterns";

import { Construct } from "constructs";

export class AmazonEcsFirelensKdfStack extends Stack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props);

    const vpc = Vpc.fromLookup(this, "Vpc", {
      vpcName: "pinnacle",
    });

    const cluster = ecs.Cluster.fromClusterAttributes(this, "Cluster", {
      vpc: vpc,
      securityGroups: [],
      clusterName: Fn.importValue("PinnacleEcsClusterName"),
    });

    const fargateTaskDefinition = new ecs.FargateTaskDefinition(
      this,
      "FargateTaskDefinition",
      {
        family: "PinnacleEcsFirelensKdf",
        memoryLimitMiB: 512,
        cpu: 256,
      }
    );

    const fireLensLogDriver = new ecs.FireLensLogDriver({
      options: {
        Name: "firehose",
        region: this.region,
        delivery_stream: "aws-ecs-" + cluster.clusterName,
        retry_limit: "2",
      },
      tag: "pinnacle",
    });

    new ecs.ContainerDefinition(this, "ContainerDefinitionApp", {
      containerName: "SimpleWebApp",
      image: ContainerImage.fromRegistry("httpd:2.4"),
      portMappings: [{ containerPort: 80 }],
      taskDefinition: fargateTaskDefinition,
      essential: true,
      entryPoint: ["sh", "-c"],
      command: [
        "echo '<html><head><title>Amazon ECS Sample App</title><style>body {margin-top: 40px; background-color: #333;} </style> </head><body> <div style=color:white;text-align:center> <h1>Amazon ECS Sample App</h1> <h2>Congratulations!</h2> <p>Your application is now running on a container in Amazon ECS.</p> </div></body></html>' >  /usr/local/apache2/htdocs/index.html && httpd-foreground",
      ],
      logging: fireLensLogDriver,
    });

    new ecsPatterns.ApplicationLoadBalancedFargateService(this, "Service", {
      cluster,
      serviceName: "PinnacleEcsFirelensKdf",
      memoryLimitMiB: 1024,
      desiredCount: 1,
      cpu: 512,
      taskDefinition: fargateTaskDefinition,
      loadBalancerName: "pinnacle-ecs-firelens-kdf-lb",
    });
  }
}
