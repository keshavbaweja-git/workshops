import { CfnOutput, Stack, StackProps } from "aws-cdk-lib";
import {
  GatewayVpcEndpoint,
  GatewayVpcEndpointAwsService, Vpc
} from "aws-cdk-lib/aws-ec2";
import * as iam from "aws-cdk-lib/aws-iam";
import { ManagedPolicy, ServicePrincipal } from "aws-cdk-lib/aws-iam";
import { Construct } from "constructs";

export class PinnacleGlueStack extends Stack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props);

    const glueServiceRole = new iam.Role(this, "GlueServiceRole", {
      assumedBy: new ServicePrincipal("glue.amazonaws.com"),
      roleName: "AWSGlueServiceRoleDefault",
      managedPolicies: [
        ManagedPolicy.fromAwsManagedPolicyName(
          "service-role/AWSGlueServiceRole"
        ),
        ManagedPolicy.fromAwsManagedPolicyName("AmazonS3FullAccess"),
      ],
    });

    new CfnOutput(this, "GlueServiceRoleArn", {
      exportName: "GlueServiceRoleArn",
      value: glueServiceRole.roleArn,
    });

    const vpc = Vpc.fromLookup(this, "VPC", { vpcId: "vpc-02eaa7bdb3bf1573c" });
    new GatewayVpcEndpoint(this, "S3GatewayVpcEndpoint", {
      vpc,
      service: GatewayVpcEndpointAwsService.S3,
    });
  }
}
