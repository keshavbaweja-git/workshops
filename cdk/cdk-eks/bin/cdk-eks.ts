import "source-map-support/register";
import * as cdk from "aws-cdk-lib";
import * as blueprints from "@aws-quickstart/eks-blueprints";
import { ArnPrincipal } from "aws-cdk-lib/aws-iam";

const app = new cdk.App();
const account = process.env.ACCOUNT_ID;
const region = "ap-southeast-1";

const addOns: Array<blueprints.ClusterAddOn> = [
  new blueprints.addons.ArgoCDAddOn(),
  new blueprints.addons.AppMeshAddOn(),
  new blueprints.addons.CalicoAddOn(),
  new blueprints.addons.MetricsServerAddOn(),
  new blueprints.addons.ClusterAutoScalerAddOn(),
  new blueprints.addons.ContainerInsightsAddOn(),
  new blueprints.addons.AwsLoadBalancerControllerAddOn(),
  new blueprints.addons.VpcCniAddOn(),
  new blueprints.addons.CoreDnsAddOn(),
  new blueprints.addons.KubeProxyAddOn(),
  new blueprints.addons.XrayAddOn(),
];

const platformTeam = new blueprints.PlatformTeam({
  name: "platform-admin",
  users: [new ArnPrincipal("arn:aws:iam::" + account + ":user/admin1")],
});

blueprints.EksBlueprint.builder()
  .account(account)
  .region(region)
  .addOns(...addOns)
  .teams(platformTeam)
  .name("mycluster2")
  .build(app, "mycluster2");
