#!/usr/bin/env node
import * as cdk from "aws-cdk-lib";
import "source-map-support/register";
import { BluegreenEcsIamStack } from "../lib/bluegreen-ecs-iam-stack";
import { BluegreenStack } from "../lib/bluegreen-stack";

const env = {
  account: process.env.CDK_DEFAULT_ACCOUNT,
  region: process.env.CDK_DEFAULT_REGION,
};

const app = new cdk.App();
new BluegreenEcsIamStack(app, "BluegreenEcsIamStack", { env });
new BluegreenStack(app, "BluegreenStack", { env });
