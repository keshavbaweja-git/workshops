import { Stack, StackProps } from "aws-cdk-lib";
import * as ec2 from "aws-cdk-lib/aws-ec2";
import { Vpc } from "aws-cdk-lib/aws-ec2";
import * as ecs from "aws-cdk-lib/aws-ecs";
import * as elbv2 from "aws-cdk-lib/aws-elasticloadbalancingv2";
import {
  ApplicationListener,
  ApplicationLoadBalancer,
  ApplicationProtocol,
  TargetType,
} from "aws-cdk-lib/aws-elasticloadbalancingv2";
import * as codedeploy from "aws-cdk-lib/aws-codedeploy";
import { Construct } from "constructs";

export class BluegreenStack extends Stack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props);

    const vpc = Vpc.fromLookup(this, "VPC", { vpcId: "vpc-02eaa7bdb3bf1573c" });

    const ecsCluster = new ecs.Cluster(this, "EcsCluster", {
      clusterName: "BluegreenCluster",
      vpc,
    });

    this.exportValue(ecsCluster.clusterArn, { name: "EcsClusterArn" });

    const loadBalancer = new ApplicationLoadBalancer(this, "LoadBalancer", {
      loadBalancerName: "Bluegreen",
      vpc,
      vpcSubnets: { subnetType: ec2.SubnetType.PUBLIC },
      internetFacing: true,
    });

    const tg1 = new elbv2.ApplicationTargetGroup(this, "TG1", {
      targetGroupName: "BluegreenTG1",
      targetType: TargetType.IP,
      protocol: ApplicationProtocol.HTTP,
      port: 80,
      vpc,
    });

    new ApplicationListener(this, "Listener1", {
      loadBalancer: loadBalancer,
      defaultTargetGroups: [tg1],
      port: 80,
      protocol: ApplicationProtocol.HTTP,
    });

    const fargateTaskDefinition = new ecs.FargateTaskDefinition(
      this,
      "FargateTaskDefinition",
      {
        memoryLimitMiB: 512,
        cpu: 256,
      }
    );

    fargateTaskDefinition.addContainer("EchoServer", {
      image: ecs.ContainerImage.fromRegistry(
        "k8s.gcr.io/e2e-test-images/echoserver:2.5"
      ),
      portMappings: [{ containerPort: 8080 }],
    });

    const fargateService = new ecs.FargateService(this, "FargateService", {
      serviceName: "Bluegreen",
      cluster: ecsCluster,
      taskDefinition: fargateTaskDefinition,
    });

    fargateService.attachToApplicationTargetGroup(tg1);

    const tg2 = new elbv2.ApplicationTargetGroup(this, "TG2", {
      targetGroupName: "BluegreenTG2",
      targetType: TargetType.IP,
      protocol: ApplicationProtocol.HTTP,
      port: 80,
      vpc,
    });

    const codeDeployEcsApplication = new codedeploy.EcsApplication(
      this,
      "CodeDeployEcsApplication",
      {
        applicationName: "Bluegreen",
      }
    );
  }
}
