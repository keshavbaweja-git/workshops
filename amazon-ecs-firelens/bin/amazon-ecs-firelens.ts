#!/usr/bin/env node
import "source-map-support/register";
import * as cdk from "aws-cdk-lib";
import { AmazonEcsFirelensStack } from "../lib/amazon-ecs-firelens-stack";
import { AmazonEcsFirelensKdfStack } from "../lib/amazon-ecs-firelens-kdf-stack";
import { AmazonEcsFirelensKdf2Stack } from "../lib/amazon-ecs-firelens-kdf-2-stack";

const env = {
  account: process.env.CDK_DEFAULT_ACCOUNT,
  region: process.env.CDK_DEFAULT_REGION,
};

const app = new cdk.App();
new AmazonEcsFirelensStack(app, "AmazonEcsFirelensStack", { env: env });
new AmazonEcsFirelensKdfStack(app, "AmazonEcsFirelensKdfStack", { env: env });
new AmazonEcsFirelensKdf2Stack(app, "AmazonEcsFirelensKdf2Stack", { env: env });
