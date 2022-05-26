import * as blueprints from "@aws-quickstart/eks-blueprints";
import * as cdk from "aws-cdk-lib";
import * as ec2 from "aws-cdk-lib/aws-ec2";
import { InstanceType } from "aws-cdk-lib/aws-ec2";
import { KubernetesVersion, NodegroupAmiType } from "aws-cdk-lib/aws-eks";
import { ArnPrincipal } from "aws-cdk-lib/aws-iam";

const app = new cdk.App();
const account = process.env.ACCOUNT_ID;
const region = "us-east-1";

const platformTeam = new blueprints.PlatformTeam({
  name: "platform-admin",
  users: [new ArnPrincipal("arn:aws:iam::" + account + ":user/admin1")],
});

const addOns: Array<blueprints.ClusterAddOn> = [
  new blueprints.addons.AppMeshAddOn(),
  new blueprints.addons.CalicoAddOn(),
  new blueprints.addons.MetricsServerAddOn(),
  new blueprints.addons.ContainerInsightsAddOn(),
  new blueprints.addons.AwsLoadBalancerControllerAddOn(),
  new blueprints.addons.SecretsStoreAddOn(),
  new blueprints.addons.SSMAgentAddOn(),
  new blueprints.addons.NginxAddOn({
    values: {
      controller: { service: { create: false } },
    },
  }),
  new blueprints.addons.VeleroAddOn(),
  new blueprints.addons.VpcCniAddOn(),
  new blueprints.addons.CoreDnsAddOn(),
  new blueprints.addons.KubeProxyAddOn(),
  new blueprints.addons.ClusterAutoScalerAddOn(),
  new blueprints.addons.KubeviousAddOn(),
  new blueprints.addons.EbsCsiDriverAddOn(),
  new blueprints.addons.EfsCsiDriverAddOn({ replicaCount: 1 }),
];

const clusterProvider = new blueprints.GenericClusterProvider({
  version: KubernetesVersion.V1_21,
  managedNodeGroups: [
    {
      id: "mng1",
      amiType: NodegroupAmiType.AL2_X86_64,
      instanceTypes: [new InstanceType("m5.large")],
      diskSize: 25,
      nodeGroupSubnets: { subnetType: ec2.SubnetType.PRIVATE_WITH_NAT },
    },
  ],
});

blueprints.EksBlueprint.builder()
  .name("mycluster2")
  .account(account)
  .region(region)
  .addOns(...addOns)
  .clusterProvider(clusterProvider)
  .teams(platformTeam)
  .enableControlPlaneLogTypes("api")
  .build(app, "mycluster2");
