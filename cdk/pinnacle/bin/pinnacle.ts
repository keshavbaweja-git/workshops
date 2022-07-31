#!/usr/bin/env node
import * as cdk from "aws-cdk-lib";
import "source-map-support/register";
import { PinnacleIamStack } from "../lib/pinnacle-iam-stack";

const app = new cdk.App();
new PinnacleIamStack(app, "PinnacleIamStack", {
  env: {
    account: process.env.CDK_ACCOUNT_ID,
    region: process.env.CDK_REGION_ID,
  },
});
