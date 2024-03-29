import { Stack, StackProps } from "aws-cdk-lib";
import { Construct } from "constructs";
import { Vpc } from "aws-cdk-lib/aws-ec2";
import * as ecs from "aws-cdk-lib/aws-ecs";
import { ContainerImage } from "aws-cdk-lib/aws-ecs";
import * as ecsPatterns from "aws-cdk-lib/aws-ecs-patterns";

export class AmazonEcsFirelensStack extends Stack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props);

    const vpc = Vpc.fromLookup(this, "Vpc", {
      vpcName: "pinnacle",
    });

    const cluster = new ecs.Cluster(this, "Cluster", {
      vpc: vpc,
      clusterName: "pinnacle",
    });

    this.exportValue(cluster.clusterArn, { name: "PinnacleEcsClusterArn" });
    this.exportValue(cluster.clusterName, { name: "PinnacleEcsClusterName" });

    const fargateTaskDefinition = new ecs.FargateTaskDefinition(
      this,
      "FargateTaskDefinition",
      {
        memoryLimitMiB: 512,
        cpu: 256,
      }
    );

    const fireLensLogDriver = new ecs.FireLensLogDriver({
      options: {
        Name: "cloudwatch",
        region: this.region,
        log_group_name: "/aws/ecs/" + cluster.clusterName + "/webserver",
        log_stream_name: "$(ecs_task_id)",
        auto_create_group: "true",
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
      memoryLimitMiB: 1024,
      desiredCount: 1,
      cpu: 512,
      taskDefinition: fargateTaskDefinition,
      loadBalancerName: "pinnacle-ecs-lb",
    });
  }
}
