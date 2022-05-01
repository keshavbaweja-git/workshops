#!/usr/bin/env node
import * as cdk from 'aws-cdk-lib';
import 'source-map-support/register';
import { PinnacleMiscStack } from '../lib/pinnacle-misc-stack';

const app = new cdk.App();
new PinnacleMiscStack(app, "PinnacleMiscStack");

