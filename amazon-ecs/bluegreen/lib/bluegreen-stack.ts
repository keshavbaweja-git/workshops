import { Stack, StackProps } from "aws-cdk-lib";
import * as ec2 from "aws-cdk-lib/aws-ec2";
import { Vpc } from "aws-cdk-lib/aws-ec2";
import * as elbv2 from "aws-cdk-lib/aws-elasticloadbalancingv2";
import {
  ApplicationListener,
  ApplicationLoadBalancer,
  ApplicationProtocol,
  ListenerAction,
  TargetType
} from "aws-cdk-lib/aws-elasticloadbalancingv2";
import { Construct } from "constructs";

export class BluegreenStack extends Stack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props);

    const vpc = Vpc.fromLookup(this, "VPC", { vpcId: "vpc-02eaa7bdb3bf1573c" });

    const loadBalancer = new ApplicationLoadBalancer(this, "LoadBalancer", {
      vpc,
      vpcSubnets: { subnetType: ec2.SubnetType.PUBLIC },
    });

    const tg1 = new elbv2.ApplicationTargetGroup(this, "TG1", {
      targetType: TargetType.IP,
      protocol: ApplicationProtocol.HTTP,
      port: 80,
      vpc,
    });

    const listener1 = new ApplicationListener(this, "Listener1", {
      loadBalancer: loadBalancer,
      defaultTargetGroups: [tg1],
      port: 80,
      protocol: ApplicationProtocol.HTTP
    });
  }
}
