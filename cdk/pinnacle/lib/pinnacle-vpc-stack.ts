import { CfnOutput, Stack, StackProps } from "aws-cdk-lib";
import * as ec2 from "aws-cdk-lib/aws-ec2";
import { Construct } from "constructs";

export class PinnacleVpcStack extends Stack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props);

    const pinnacleVpc = new ec2.Vpc(this, "PinnacleVpc", {
      cidr: "10.1.0.0/16",
      vpcName: "pinnacle",
    });

    new CfnOutput(this, "PinnacleVpcId", {
      exportName: "PinnacleVpcId",
      value: pinnacleVpc.vpcId,
    });
  }
}
