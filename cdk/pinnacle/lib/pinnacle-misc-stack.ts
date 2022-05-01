import { CfnOutput, Stack, StackProps } from "aws-cdk-lib";
import { Construct } from "constructs";
import * as appmesh from 'aws-cdk-lib/aws-appmesh';
import * as ecr from 'aws-cdk-lib/aws-ecr'; 

export class PinnacleMiscStack extends Stack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props);
    const mesh = new appmesh.Mesh(this, "AppMesh", {
      meshName: "myAwsMesh",
    });

    new CfnOutput(this, "appMeshARN", {
        value: mesh.meshArn,
        description: "ARN of App Mesh",
        exportName: "appMeshARN"
    });
    
    const repo = new ecr.Repository(this, "YelbServerV2Repo", {
        repositoryName: "yelb-appserver-v2",
    });

    new CfnOutput(this, "yelbServerV2RepoArn", {
        value: repo.repositoryArn,
        description: "ARN of Yelb Server v2 repository",
        exportName: "yelbServerV2RepoArn"
    });
  }
}
