#!/usr/bin/env node
import "source-map-support/register";
import * as cdk from "aws-cdk-lib";
import { BluegreenStack } from "../lib/bluegreen-stack";

const app = new cdk.App();
new BluegreenStack(app, "BluegreenStack", {
  env: {
    account: process.env.CDK_DEFAULT_ACCOUNT,
    region: process.env.CDK_DEFAULT_REGION,
  },
});
