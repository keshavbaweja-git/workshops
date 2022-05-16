#!/usr/bin/env node
import "source-map-support/register";
import * as cdk from "aws-cdk-lib";
import { PinnacleGlueStack } from "../lib/pinnacle-glue-stack";

const app = new cdk.App();
new PinnacleGlueStack(app, "PinnacleGlueStack", {
  env: {
    account: process.env.CDK_DEFAULT_ACCOUNT,
    region: process.env.CDK_DEFAULT_REGION,
  },
});
