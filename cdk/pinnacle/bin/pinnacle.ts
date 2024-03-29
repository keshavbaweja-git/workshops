#!/usr/bin/env node
import * as cdk from "aws-cdk-lib";
import "source-map-support/register";
import { PinnacleIamStack } from "../lib/pinnacle-iam-stack";
import { PinnacleVpcStack } from "../lib/pinnacle-vpc-stack";
import { Pinnacle2VpcStack } from "../lib/pinnacle2-vpc-stack";

const app = new cdk.App();
new PinnacleIamStack(app, "PinnacleIamStack", {
  env: {
    account: process.env.CDK_ACCOUNT_ID,
    region: process.env.CDK_REGION_ID,
  },
});
new PinnacleVpcStack(app, "PinnacleVpcStack", {
  env: {
    account: process.env.CDK_ACCOUNT_ID,
    region: process.env.CDK_REGION_ID,
  },
});
new Pinnacle2VpcStack(app, "Pinnacle2VpcStack", {
  env: {
    account: process.env.CDK_ACCOUNT_ID,
    region: process.env.CDK_REGION_ID,
  },
});
