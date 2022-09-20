import { CfnOutput, Stack, StackProps } from "aws-cdk-lib";
import * as ec2 from "aws-cdk-lib/aws-ec2";
import { Construct } from "constructs";

export class Pinnacle2VpcStack extends Stack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props);

    const pinnacle2Vpc = new ec2.Vpc(this, "Pinnacle2Vpc", {
      cidr: "10.20.0.0/16",
      vpcName: "pinnacle2",
      maxAzs: 3,
    });

    new CfnOutput(this, "Pinnacle2VpcId", {
      exportName: "Pinnacle2VpcId",
      value: pinnacle2Vpc.vpcId,
    });
  }
}
