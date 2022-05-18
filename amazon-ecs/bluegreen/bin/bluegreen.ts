#!/usr/bin/env node
import "source-map-support/register";
import * as cdk from "aws-cdk-lib";
import { BluegreenStack } from "../lib/bluegreen-stack";
import { BluegreenEcsClusterStack } from "../lib/bluegreen-ecscluster-stack";

const env = {
  account: process.env.CDK_DEFAULT_ACCOUNT,
  region: process.env.CDK_DEFAULT_REGION,
};

const app = new cdk.App();
new BluegreenEcsClusterStack(app, "BluegreenEcsClusterStack", { env });
new BluegreenStack(app, "BluegreenStack", { env });
