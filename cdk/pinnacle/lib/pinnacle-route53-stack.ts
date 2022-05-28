import { CfnOutput, Stack, StackProps } from "aws-cdk-lib";
import { Construct } from "constructs";
import * as route53 from "aws-cdk-lib/aws-route53";
import * as acm from "aws-cdk-lib/aws-certificatemanager";

const zoneName = "northpinnacle.com";

export class PinnacleRoute53Stack extends Stack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props);
    const hostedZone = new route53.HostedZone(this, "HostedZone", {
      zoneName: zoneName,
    });
    new acm.Certificate(this, "Certificate", {
      domainName: "wordsmith" + zoneName,
      validation: acm.CertificateValidation.fromDns(hostedZone),
    });
  }
}
