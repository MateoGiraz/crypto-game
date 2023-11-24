require('dotenv').config()
require('@nomiclabs/hardhat-ethers')
require('solidity-coverage')
require('hardhat-contract-sizer')

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: '0.8.16',
  networks: {
    ganache: {
      url: process.env.PRIVATE_URL,
      accounts: [process.env.PRIVATE_KEY],
    },
  },
  paths: {
    sources: './src',
    tests: './src/test',
    cache: './cache',
    artifacts: './artifacts',
  },
}
