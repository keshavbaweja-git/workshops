import { Fn, Stack, StackProps } from "aws-cdk-lib";
import { Vpc } from "aws-cdk-lib/aws-ec2";
import * as ecs from "aws-cdk-lib/aws-ecs";
import { ContainerImage, FirelensConfigFileType } from "aws-cdk-lib/aws-ecs";
import * as ecsPatterns from "aws-cdk-lib/aws-ecs-patterns";
import * as iam from "aws-cdk-lib/aws-iam";

import { Construct } from "constructs";

export class AmazonEcsFirelensParserStack extends Stack {
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

    const taskRole = new iam.Role(this, "TaskRole", {
      roleName: "AmazonEcsFirelensParserTaskRole",
      assumedBy: new iam.ServicePrincipal("ecs-tasks.amazonaws.com"),
    });

    new iam.Policy(this, "TaskPolicy", {
      policyName: "AmazonEcsFirelensParserTaskPolicy",
      roles: [taskRole],
      statements: [
        new iam.PolicyStatement({
          sid: "AllowS3Read",
          actions: ["s3:GetObject"],
          resources: ["*"],
        }),
      ],
    });

    const fargateTaskDefinition = new ecs.FargateTaskDefinition(
      this,
      "FargateTaskDefinition",
      {
        family: "PinnacleEcsFirelensParser",
        memoryLimitMiB: 512,
        cpu: 256,
        taskRole: taskRole,
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

    fargateTaskDefinition.addFirelensLogRouter("log-router", {
      image: ecs.ContainerImage.fromRegistry(
        "public.ecr.aws/aws-observability/aws-for-fluent-bit:stable"
      ),
      firelensConfig: {
        type: ecs.FirelensLogRouterType.FLUENTBIT,
        options: {
          configFileType: FirelensConfigFileType.S3,
          configFileValue:
            "arn:aws:s3:::" +
            props?.env?.account +
            "-" +
            props?.env?.region +
            "-ecs-pinnacle/fluentbit-parsers-conf/parse-apache.conf",
        },
      },
      logging: new ecs.AwsLogDriver({ streamPrefix: "firelens" }),
      memoryReservationMiB: 50,
      portMappings: [{ containerPort: 24224 }],
    });

    new ecsPatterns.ApplicationLoadBalancedFargateService(this, "Service", {
      cluster,
      serviceName: "PinnacleEcsFirelensParser",
      memoryLimitMiB: 1024,
      desiredCount: 1,
      cpu: 512,
      taskDefinition: fargateTaskDefinition,
      loadBalancerName: "pinnacle-ecs-firelens-parser-lb",
    });
  }
}
