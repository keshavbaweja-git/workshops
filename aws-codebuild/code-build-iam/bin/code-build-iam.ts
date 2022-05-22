#!/usr/bin/env node
import "source-map-support/register";
import * as cdk from "aws-cdk-lib";
import { CodeBuildIamStack } from "../lib/code-build-iam-stack";

const app = new cdk.App();
new CodeBuildIamStack(app, "CodeBuildIamStack", {});
