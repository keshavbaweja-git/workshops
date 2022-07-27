#!/usr/bin/env node
import * as cdk from "aws-cdk-lib";
import "source-map-support/register";
import { PinnacleStackUsEast1 } from "../lib/pinnacle-stack-us-east-1";

const app = new cdk.App();
new PinnacleStackUsEast1(app, "PinnacleStack", {
  env: {
    account: process.env.CDK_ACCOUNT_ID,
    region: process.env.CDK_REGION_ID,
  },
});
