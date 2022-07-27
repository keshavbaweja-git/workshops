import { CfnOutput, Stack, StackProps } from "aws-cdk-lib";
import * as ec2 from "aws-cdk-lib/aws-ec2";
import { Construct } from "constructs";

export class PinnacleStack extends Stack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props);

    const vpcVpn = new ec2.Vpc(this, "VpcVpn", {
      cidr: "10.1.0.0/16",
      vpcName: "pinnacle-singapore-vpn",
    });

    const vpcOnPremises = new ec2.Vpc(this, "VpcOnPremises", {
      cidr: "10.2.0.0/16",
      vpcName: "pinnacle-singapore-on-premises",
    });

    new CfnOutput(this, "vpcVpnId", {
      exportName: "VpcVpnId",
      value: vpcVpn.vpcId,
    });

    new CfnOutput(this, "vpcOnPremisesId", {
      exportName: "VpcOnPremisesId",
      value: vpcOnPremises.vpcId,
    });
  }
}
