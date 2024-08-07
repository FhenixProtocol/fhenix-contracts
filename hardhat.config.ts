const docgen = require('solidity-docgen');

require('@nomiclabs/hardhat-truffle5');
require('hardhat-exposed');
require('fhenix-hardhat-plugin');
require('@nomicfoundation/hardhat-ethers');

const config = {
  defaultNetwork: "localfhenix",
  networks: {
    localfhenix: {
      url: "http://localhost:42069",
      // chainId: TESTNET_CHAIN_ID,
      // gas: "auto",
      // gasMultiplier: 1.2,
      // gasPrice: "auto",
      // httpHeaders: {},
      timeout: 10_000,
      accounts: {
        mnemonic: "demand hotel mass rally sphere tiger measure sick spoon evoke fashion comfort",
        path: "m/44'/60'/0'/0",
        count: 10,
        // passphrase: "",
      },
    },
  },
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
