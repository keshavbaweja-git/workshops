import { Stack, StackProps } from "aws-cdk-lib";
import * as iam from "aws-cdk-lib/aws-iam";
import { Effect, PolicyStatement } from "aws-cdk-lib/aws-iam";
import { Construct } from "constructs";

export class CodeBuildIamStack extends Stack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props);

    const codeBuildServiceRole = new iam.Role(this, "CodeBuildServiceRole", {
      assumedBy: new iam.ServicePrincipal("codebuild.amazonaws.com"),
      roleName: "CodeBuildServiceRole",
    });

    const codeBuildServicePolicy = new iam.Policy(
      this,
      "CodeBuildServicePolicy",
      {
        policyName: "CodeBuildServicePolicy",
        statements: [
          new PolicyStatement({
            sid: "CloudWatchLogsPolicy",
            effect: Effect.ALLOW,
            actions: [
              "logs:CreateLogGroup",
              "logs:CreateLogStream",
              "logs:PutLogEvents",
            ],
            resources: ["*"],
          }),
          new PolicyStatement({
            sid: "CodeCommitPolicy",
            effect: Effect.ALLOW,
            actions: ["codecommit:GitPull"],
            resources: ["*"],
          }),
          new PolicyStatement({
            sid: "S3GetObjectPolicy",
            effect: Effect.ALLOW,
            actions: ["s3:GetObject", "s3:GetObjectVersion"],
            resources: ["*"],
          }),
          new PolicyStatement({
            sid: "S3PutObjectPolicy",
            effect: Effect.ALLOW,
            actions: ["s3:PutObject"],
            resources: ["*"],
          }),
          new PolicyStatement({
            sid: "S3BucketIdentity",
            effect: Effect.ALLOW,
            actions: ["s3:GetBucketAcl", "s3:GetBucketLocation"],
            resources: ["*"],
          }),
          new PolicyStatement({
            sid: "EcrActions",
            effect: Effect.ALLOW,
            actions: [
              "ecr:BatchCheckLayerAvailability",
              "ecr:CompleteLayerUpload",
              "ecr:GetAuthorizationToken",
              "ecr:InitiateLayerUpload",
              "ecr:PutImage",
              "ecr:UploadLayerPart",
            ],
            resources: ["*"],
          }),
        ],
      }
    );

    codeBuildServicePolicy.attachToRole(codeBuildServiceRole);
  }
}
