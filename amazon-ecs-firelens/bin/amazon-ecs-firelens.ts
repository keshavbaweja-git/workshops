#!/usr/bin/env node
import "source-map-support/register";
import * as cdk from "aws-cdk-lib";
import { AmazonEcsFirelensStack } from "../lib/amazon-ecs-firelens-stack";

const env = {
  account: process.env.CDK_DEFAULT_ACCOUNT,
  region: process.env.CDK_DEFAULT_REGION,
};

const app = new cdk.App();
new AmazonEcsFirelensStack(app, "AmazonEcsFirelensStack", { env: env });
