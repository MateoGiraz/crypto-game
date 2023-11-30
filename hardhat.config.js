require('dotenv').config()
require('@nomiclabs/hardhat-ethers')
require("@nomiclabs/hardhat-waffle");
require('solidity-coverage')
require('hardhat-contract-sizer')

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: '0.8.16',
  networks: {
    ganache: {
      url: process.env.PRIVATE_URL ?? 'HTTP://127.0.0.1:7545',
      accounts: [
        process.env.PRIVATE_KEY ??
          '0xf0ff394a2812f2b3c5de4b9d32dedc1d9811b30354fc326a04b66b800ab48497',
      ],
    },
  },
  paths: {
    sources: './src',
    tests: './src/test',
    cache: './cache',
    artifacts: './artifacts',
  },
}
