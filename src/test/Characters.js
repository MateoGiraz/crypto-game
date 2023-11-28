// SPDX-License-Identifier: MIT
const { expect } = require('chai')
const { ethers } = require('hardhat')

describe('Character', function () {
  let character
  let ownersContract
  let rubie
  let owner
  let recipient

  beforeEach(async function () {
    ;[owner, recipient] = await ethers.getSigners()

    // Deploy OwnersContract
    const OwnersContract = await ethers.getContractFactory('OwnersContract')
    ownersContract = await OwnersContract.deploy(1)
    await ownersContract.deployed()

    // Deploy Rubie
    const Rubie = await ethers.getContractFactory('Rubie')
    rubie = await Rubie.deploy('Rubie', 'RBE', ownersContract.address)
    await rubie.deployed()

    // Deploy Character
    const Character = await ethers.getContractFactory('Character')
    character = await Character.deploy(
      'Character',
      'CHR',
      'tokenURI',
      ownersContract.address,
    )
    await character.deployed()

    await ownersContract.addContract('Rubie', rubie.address)
    await ownersContract.addContract('Character', character.address)
  })

  it('should have correct initial values', async function () {
    expect(await character.name()).to.equal('Character')
    expect(await character.symbol()).to.equal('CHR')
    expect(await character.tokenURI()).to.equal('tokenURI')
    expect((await character.totalSupply()).toNumber()).to.equal(0)
  })
})
