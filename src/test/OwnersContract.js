// SPDX-License-Identifier: MIT
const { expect } = require('chai')
const { ethers } = require('hardhat')

describe('OwnersContract', function () {
  let ownersContract
  let owner
  let newOwner
  let testContract
  const testName = 'Rubie'
  const contractName = 'OwnersContract'
  const tokenFee = 1

  beforeEach(async function () {
    ;[owner, newOwner] = await ethers.getSigners()

    const OwnersContract = await ethers.getContractFactory(contractName)
    ownersContract = await OwnersContract.deploy(tokenFee)
    await ownersContract.deployed()

    const TestContract = await ethers.getContractFactory(testName)
    testContract = await TestContract.deploy(
      'Rubie',
      'RBE',
      ownersContract.address,
    )
    await testContract.deployed()
  })

  it('should initialize with the correct owner and token sell fee percentage', async function () {
    const ownerIndex = await ownersContract.ownerIndex()
    const tokenSellFeePercentage = await ownersContract.tokenSellFeePercentage()

    expect(ownerIndex.toNumber()).to.equal(1)
    expect(tokenSellFeePercentage.toNumber()).to.equal(tokenFee)
  })

  it('should allow adding a new owner', async function () {
    await ownersContract.addOwner(newOwner.address)

    const isOwner = await ownersContract.owners(newOwner.address)
    const ownerIndex = await ownersContract.ownerIndex()

    expect(isOwner).to.be.true
    expect(ownerIndex.toNumber()).to.equal(2)
  })

  it('should allow adding a contract', async function () {
    await ownersContract.addContract(contractName, testContract.address)

    const contractAddress = await ownersContract.addressOf(contractName)

    expect(contractAddress).to.equal(testContract.address)
  })

  it('should allow withdrawing earnings', async function () {
    await ownersContract.addOwner(newOwner.address)
    await ownersContract.WithdrawEarnings()

    const ownerBalance = await ethers.provider.getBalance(newOwner.address)

    expect(ownerBalance.gt(0)).to.be.true
  })
})
