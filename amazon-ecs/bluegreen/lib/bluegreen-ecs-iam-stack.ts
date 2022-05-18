import { Stack, StackProps } from "aws-cdk-lib";
import { ManagedPolicy, Role, ServicePrincipal } from "aws-cdk-lib/aws-iam";
import { Construct } from "constructs";

export class BluegreenEcsIamStack extends Stack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props);

    new Role(this, "EcsCodeDeployRole", {
      assumedBy: new ServicePrincipal("codedeploy.amazonaws.com"),
      roleName: "ecsCodeDeployRole",
      managedPolicies: [
        ManagedPolicy.fromAwsManagedPolicyName(
          "AWSCodeDeployRoleForECS"
        )],
    });
  }
}
