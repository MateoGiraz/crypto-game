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
    sepolia: {
      url: 'https://sepolia.infura.io/v3/11d4fffc5f264c44849bfb8d0fb6d2b5',
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
