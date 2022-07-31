import { CfnOutput, Stack, StackProps } from "aws-cdk-lib";
import * as iam from "aws-cdk-lib/aws-iam";
import { ManagedPolicy } from "aws-cdk-lib/aws-iam";
import { Construct } from "constructs";

export class PinnacleIamStack extends Stack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props);

    const pinnacleInstanceRole = new iam.Role(this, "PinnacleInstanceRole", {
      assumedBy: new iam.ServicePrincipal("ec2.amazonaws.com"),
      roleName: "PinnacleInstanceRole",
    });

    const awsManagedPolicyNames: string[] = [
      "AmazonSSMManagedInstanceCore",
      "CloudWatchAgentServerPolicy",
    ];

    for (const awsManagedPolicyName of awsManagedPolicyNames) {
      pinnacleInstanceRole.addManagedPolicy(
        ManagedPolicy.fromAwsManagedPolicyName(awsManagedPolicyName)
      );
    }

    new CfnOutput(this, "PinnacleInstanceRoleArn", {
      exportName: "PinnacleInstanceRoleArn",
      value: pinnacleInstanceRole.roleArn,
    });
  }
}
