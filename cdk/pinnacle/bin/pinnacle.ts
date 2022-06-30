#!/usr/bin/env node
import * as cdk from "aws-cdk-lib";
import "source-map-support/register";
import { PinnacleStack } from "../lib/pinnacle-stack";

const app = new cdk.App();
new PinnacleStack(app, "PinnacleStack", {
  env: {
    account: process.env.CDK_ACCOUNT_ID,
    region: "ap-southeast-1",
  },
});
