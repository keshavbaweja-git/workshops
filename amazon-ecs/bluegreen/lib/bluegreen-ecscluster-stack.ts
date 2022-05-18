import { Stack, StackProps } from "aws-cdk-lib";
import { Vpc } from "aws-cdk-lib/aws-ec2";
import { Construct } from "constructs";
import * as ecs from "aws-cdk-lib/aws-ecs";

export class BluegreenEcsClusterStack extends Stack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props);

    const vpc = Vpc.fromLookup(this, "VPC", { vpcId: "vpc-02eaa7bdb3bf1573c" });

    const ecsCluster = new ecs.Cluster(this, "EcsCluster", {
      clusterName: "BluegreenCluster",
      vpc,
    });
  }
}
