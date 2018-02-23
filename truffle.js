module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
};

var secretData = require('./secrets.js');

require('dotenv').config();
require('babel-register');
require('babel-polyfill');

require('babel-node-modules')([
  'zeppelin-solidity'
])

var HDWalletProvider = require("truffle-hdwallet-provider");


var infuraRinkebyUrl = secretData.INFURA_RINKEBY_URL;
var mnemonic = secretData.SECRET_MNEMONIC;
var infuraMainUrl = secretData.INFURA_MAIN_URL;
var provider = new HDWalletProvider(mnemonic, infuraRinkebyUrl);
var providerMain = new HDWalletProvider(mnemonic, infuraMainUrl);

console.log("Public key = "+provider.address);

module.exports = {
  networks: {
    development: {
      host: 'localhost',
      port: 8545,
      network_id: '*', // eslint-disable-line camelcase
    },
    rinkeby: {
      provider: provider,
      network_id: 4, // eslint-disable-line camelcase
      gasPrice: "5000000000",
      gas: 5000000,
    },
    main: {
      provider: providerMain,
      network_id: 1, // eslint-disable-line camelcase
      gasPrice: "1000000000",
      gas: 5000000,
    },
    coverage: {
      host: 'localhost',
      network_id: '*', // eslint-disable-line camelcase
      port: 8555,
      gas: 0xfffffffffff,
      gasPrice: 0x01,
    },
    testrpc: {
      host: 'localhost',
      port: 8545,
      network_id: '*', // eslint-disable-line camelcase
    },
    ganache: {
      host: 'localhost',
      port: 7545,
      network_id: '*', // eslint-disable-line camelcase
    },
  },
};
