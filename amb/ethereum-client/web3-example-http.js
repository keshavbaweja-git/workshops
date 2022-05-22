import Web3 from 'web3';
import AWSHttpProvider from './aws-http-provider.js';
const endpoint = process.env.AMB_HTTP_ENDPOINT
const web3 = new Web3(new AWSHttpProvider(endpoint));
web3.eth.getNodeInfo().then(console.log);