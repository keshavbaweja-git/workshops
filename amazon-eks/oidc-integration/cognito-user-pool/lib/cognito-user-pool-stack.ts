import { Stack, StackProps, CfnOutput } from 'aws-cdk-lib';
import { Construct } from 'constructs';
import * as cognito from 'aws-cdk-lib/aws-cognito';

export class CognitoUserPoolStack extends Stack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props);
    
    const userPoolName = 'keshavkb3-userpool';

    const pool = new cognito.UserPool(this, 'userpool', {
      userPoolName: userPoolName,
      passwordPolicy: {
        minLength: 8,
        requireLowercase: false,
        requireUppercase: false,
        requireDigits: false,
        requireSymbols: false,
      },
      selfSignUpEnabled: true,
      signInAliases: {
        email: true,
      },
      autoVerify: {
        email: false,
      },
      accountRecovery: cognito.AccountRecovery.NONE,
      signInCaseSensitive: false,
    });

    const client = pool.addClient('client', {
      generateSecret: false,
      authFlows: {
        adminUserPassword: true,
        userPassword: true,
      },
      oAuth: {
        flows: {
          implicitCodeGrant: true,
        }
      },
    });

    pool.addDomain("CognitoDomain", {
      cognitoDomain: {
        domainPrefix: userPoolName,
      },
    });

    const region = Stack.of(this).region
    const urlSuffix = Stack.of(this).urlSuffix
    const issuerUrl = `https://cognito-idp.${region}.${urlSuffix}/${pool.userPoolId}`;
    new CfnOutput(this, 'IssuerUrl', { value: issuerUrl })
    new CfnOutput(this, 'PoolId', { value: pool.userPoolId })
    new CfnOutput(this, 'ClientId', { value: client.userPoolClientId })
  }
}
