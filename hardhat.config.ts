const docgen = require('solidity-docgen');

require('@nomiclabs/hardhat-truffle5');
require('hardhat-exposed');

const config = {
  paths: {
    artifacts: "./artifacts",
    cache: "./cache",
    sources: "./contracts",
  },
  solidity: {
    version: "0.8.20",
  },
  docgen: {
      pages: "items"
  },
  exposed: {
    imports: true,
    initializers: true,
    exclude: ['vendor/**/*'],
  },
};
  
module.exports = config;
