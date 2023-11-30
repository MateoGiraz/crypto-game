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
    sepolia: {
      url: 'https://sepolia.infura.io/v3/dad7fa7ce0a64d90a55269735c782d8d',
      accounts: ['0xb2b165973291cd1c9051aa1e6952554743b29be0603b1d49c97cd5d0580ebe9e'],
    },
  },
  paths: {
    sources: './src',
    tests: './src/test',
    cache: './cache',
    artifacts: './artifacts',
  },
}
