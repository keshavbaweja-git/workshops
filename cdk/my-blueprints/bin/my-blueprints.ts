import * as blueprints from "@aws-quickstart/eks-blueprints";
import {
  cloudWatchDeploymentMode,
  ControlPlaneLogType,
} from "@aws-quickstart/eks-blueprints";
import * as cdk from "aws-cdk-lib";
import * as ec2 from "aws-cdk-lib/aws-ec2";
import { InstanceType } from "aws-cdk-lib/aws-ec2";
import { KubernetesVersion, NodegroupAmiType } from "aws-cdk-lib/aws-eks";
import { ArnPrincipal } from "aws-cdk-lib/aws-iam";

const app = new cdk.App();
const account = process.env.CDK_ACCOUNT_ID!;
const region = process.env.CDK_REGION;
const clusterName = "mycluster4";

const platformTeam = new blueprints.PlatformTeam({
  name: "platform-admin",
  users: [new ArnPrincipal("arn:aws:iam::" + account + ":user/admin1")],
});

const projectATeam = new blueprints.ApplicationTeam({
  name: "project-a-team",
  namespace: "projecta",
  namespaceLabels: { project: "a" },
  namespaceHardLimits: { "limits.cpu": "1", "limits.memory": "2Gi" },
  users: [new ArnPrincipal("arn:aws:iam::" + account + ":user/admin1")],
});

const teams: Array<blueprints.Team> = [platformTeam, projectATeam];

const addOns: Array<blueprints.ClusterAddOn> = [
  new blueprints.addons.ArgoCDAddOn(),
  new blueprints.addons.AppMeshAddOn(),
  new blueprints.addons.MetricsServerAddOn(),
  new blueprints.addons.CertManagerAddOn(),
  new blueprints.addons.AdotCollectorAddOn(),
  new blueprints.addons.CloudWatchAdotAddOn({
    deploymentMode: cloudWatchDeploymentMode.DAEMONSET,
  }),
  new blueprints.addons.AwsLoadBalancerControllerAddOn(),
  new blueprints.addons.OpaGatekeeperAddOn(),
  new blueprints.addons.CalicoOperatorAddOn(),
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
  version: KubernetesVersion.V1_23,
  managedNodeGroups: [
    {
      id: "mng1",
      amiType: NodegroupAmiType.AL2_X86_64,
      instanceTypes: [new InstanceType("c6i.xlarge")],
      diskSize: 25,
      nodeGroupSubnets: { subnetType: ec2.SubnetType.PRIVATE_WITH_EGRESS },
      minSize: 1,
      maxSize: 3,
      desiredSize: 3,
    },
  ],
});

blueprints.EksBlueprint.builder()
  .name(clusterName)
  .account(account)
  .region(region)
  .addOns(...addOns)
  .clusterProvider(clusterProvider)
  .teams(...teams)
  .enableControlPlaneLogTypes(
    ControlPlaneLogType.API,
    ControlPlaneLogType.AUDIT,
    ControlPlaneLogType.AUTHENTICATOR,
    ControlPlaneLogType.CONTROLLER_MANAGER,
    ControlPlaneLogType.SCHEDULER
  )
  .build(app, clusterName);