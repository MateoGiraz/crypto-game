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


 
  it('should unequip a weapon from the character', async function () {
    await rubie.mint(100, owner.address);
    await character.safeMint("New Character");
    const newTokenId = await character.currentTokenID();
    const weaponId = 25;
    await character.equip(newTokenId, weaponId);
    await character.unEquip(newTokenId, weaponId);
    expect(await character.isEquiped(newTokenId, weaponId)).to.be.false;
  });

  it('should equip a weapon to the character', async function () {
    await rubie.mint(100, owner.address);
    await character.safeMint("New Character");
    const newTokenId = await character.currentTokenID();
    const weaponId = 25;
    await character.equip(newTokenId, weaponId);
    expect(await character.isEquiped(newTokenId, weaponId)).to.be.true;
  });

  it('should update character stats', async function () {
    await rubie.mint(100, owner.address);
    await character.safeMint("New Character");
    const newTokenId = await character.currentTokenID();
    const attackPointsToAdd = 10;
    const armorPointsToAdd = 5;
    await character.upgradeStats(newTokenId, attackPointsToAdd, armorPointsToAdd,0);
    const metadata = await character.metadataOf(newTokenId);
    expect(metadata.attackPoints).to.equal(100 + attackPointsToAdd); // Asume que el valor inicial es 100
    expect(metadata.armorPoints).to.equal(50 + armorPointsToAdd); // Asume que el valor inicial es 50
  });
  
  
  
})
