#!/usr/bin/env node
import "source-map-support/register";
import * as cdk from "aws-cdk-lib";
import { EcsServicediscoveryStack } from "../lib/ecs-servicediscovery-stack";

const env = {
  account: process.env.CDK_DEFAULT_ACCOUNT,
  region: process.env.CDK_DEFAULT_REGION,
};

const app = new cdk.App();
new EcsServicediscoveryStack(app, "EcsServicediscoveryStack", {
  env: env,
});
