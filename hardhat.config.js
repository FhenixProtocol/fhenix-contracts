const docgen = require('solidity-docgen');

const config = {
    paths: {
      artifacts: "./artifacts",
      cache: "./cache",
      sources: "./contracts",
    },
    solidity: {
      version: "0.8.19",
    },
    docgen: {
        pages: "items"
    }
  };
  
module.exports = config;