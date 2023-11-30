// SPDX-License-Identifier: MIT
const { expect } = require('chai')
const { ethers } = require('hardhat')

describe('Character', function () {
  let character
  let weapon
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

    //Deploy Weapon
    const Weapon = await ethers.getContractFactory('Weapon');
    weapon = await Weapon.deploy('Weapon', 'WPN', 'tokenURI', ownersContract.address, character.address);
    await weapon.deployed();

    await ownersContract.addContract('Rubie', rubie.address)
    await ownersContract.addContract('Character', character.address)
    await ownersContract.addContract('Weapon', weapon.address)
  })

  it('should have correct initial values', async function () {
    expect(await character.name()).to.equal('Character')
    expect(await character.symbol()).to.equal('CHR')
    expect(await character.tokenURI()).to.equal('tokenURI')
    expect((await character.totalSupply()).toNumber()).to.equal(0)
  })

  it('should mint a new character', async function () {
    await rubie.mint(100,owner.address); 
    await character.safeMint("New Character");
    const newTokenId = await character.currentTokenID();
    expect(await character.ownerOf(newTokenId)).to.equal(owner.address);
  });

  it('should transfer a character to another account', async function () {
    await rubie.mint(100,owner.address); 
    await character.safeMint("New Character");
    const newTokenId = await character.currentTokenID();
    await character.safeTransfer(recipient.address, newTokenId);
    expect(await character.ownerOf(newTokenId)).to.equal(recipient.address);
  });

  it('should allow owner to approve another account to manage a character', async function () {
    await rubie.mint(100, owner.address);
    await character.safeMint("New Character");
    const newTokenId = await character.currentTokenID();
    await character.approve(recipient.address, newTokenId);
    expect(await character.allowance(newTokenId)).to.equal(recipient.address);
  });
  
  
  
})
