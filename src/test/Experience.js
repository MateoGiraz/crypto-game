// SPDX-License-Identifier: MIT
const chai = require('chai');
const chaiAsPromised = require('chai-as-promised');
const { ethers } = require('hardhat');

// Usar chai-as-promised
chai.use(chaiAsPromised);
const { expect } = chai;


describe('Experience', function () {
  let experience;
  let ownersContract;
  let rubie;
  let owner;
  let recipient;
  let invalidAddress = 0;

  beforeEach(async function () {
    [owner, recipient] = await ethers.getSigners();

    // Deploy OwnersContract
    const OwnersContract = await ethers.getContractFactory('OwnersContract');
    ownersContract = await OwnersContract.deploy(1);
    await ownersContract.deployed();

    // Deploy Rubie
    const Rubie = await ethers.getContractFactory('Rubie');
    rubie = await Rubie.deploy('Rubie', 'RBE', ownersContract.address);
    await rubie.deployed();

    // Deploy Experience
    const Experience = await ethers.getContractFactory('Experience');
    experience = await Experience.deploy('Experience', 'EXP', ownersContract.address);
    await experience.deployed();

    // Deploy Character
    // Deploy Character
    const Character = await ethers.getContractFactory('Character')
    character = await Character.deploy(
      'Character',
      'CHR',
      'tokenURI',
      ownersContract.address,
    )
    await character.deployed()

    

    await ownersContract.addContract('Rubie', rubie.address);
    await ownersContract.addContract('Character', character.address);
    await ownersContract.addContract('Experience', experience.address);
  });

  it('should have correct initial values', async function () {
    const maxInteger = ethers.constants.MaxUint256;

    expect(await experience.name()).to.equal('Experience');
    expect(await experience.symbol()).to.equal('EXP');
    expect((await experience.decimals()).toNumber()).to.equal(18);
    expect((await experience.totalSupply()).toNumber()).to.equal(0);
    expect((await experience.price()).toString()).to.equal(maxInteger.toString());
  });

  it('should allow setting token price', async function () {
    await experience.setPrice(1);
    const price = await experience.price();

    expect(price.toNumber()).to.equal(1);
  });

  it('should allow buying tokens with Rubie tokens', async function () {
    await experience.setPrice(1);

    await rubie.connect(owner).mint(10, owner.address);
    const initialBalance = await experience.balanceOf(owner.address);
    await rubie.setPrice(1);
    const rubiePrice = await rubie.price();

    const tokensToBuy = 10;

    await rubie.approve(experience.address, rubiePrice * tokensToBuy);
    await experience.connect(owner).buy(tokensToBuy);

    const finalBalance = await experience.balanceOf(owner.address);
    expect(finalBalance - initialBalance).to.equal(tokensToBuy);
  });

  it('should allow transferring tokens', async function () {
    await experience.setPrice(1);

    await rubie.connect(owner).mint(10, owner.address);
    await rubie.setPrice(1);
    const rubiePrice = await rubie.price();

    const tokensToBuy = 10;

    await rubie.approve(experience.address, rubiePrice * tokensToBuy);
    await experience.connect(owner).buy(tokensToBuy);

    const initialSenderBalance = await experience.balanceOf(owner.address);
    const initialRecipientBalance = await experience.balanceOf(recipient.address);

    await experience.safeTransfer(recipient.address, 10);

    const finalSenderBalance = await experience.balanceOf(owner.address);
    const finalRecipientBalance = await experience.balanceOf(recipient.address);

    expect(finalSenderBalance - initialSenderBalance).to.equal(-10);
    expect(finalRecipientBalance - initialRecipientBalance).to.equal(10);
  });

  it('should revert with invalid address for safeTransfer', async () => {
    await expect(experience.safeTransfer("0x0000000000000000000000000000000000000000", 10)).to.be.revertedWith("Invalid address");
});


it('should revert with invalid address for safeTransferFrom', async () => {
  await expect(experience.safeTransferFrom("0x0000000000000000000000000000000000000000", recipient.address, 10)).to.be.revertedWith("Invalid _from address");
});


it('should revert with invalid address for approve', async () => {
  await expect(experience.approve("0x0000000000000000000000000000000000000000", 10)).to.be.revertedWith("Invalid _spender");
});

it('should revert if non-owner tries to set price', async function () {
  await expect(experience.connect(recipient).setPrice(10))
    .to.be.revertedWith("Not the owner");
});

it('should allow owner to set price', async function () {
  await expect(experience.connect(owner).setPrice(10))
    .to.not.be.reverted;
  expect(await experience.price()).to.equal(10);
});

it('should revert if trying to set non-zero allowance on top of non-zero allowance', async function () {
  await experience.connect(owner).mintForTesting(owner.address, 10000);
  await experience.approve(recipient.address, 10);
  await expect(experience.approve(recipient.address, 20))
    .to.be.revertedWith("Invalid allowance amount. Set to zero first");
});

it('should allow setting allowance to zero and then to another value', async function () {
  await experience.connect(owner).mintForTesting(owner.address, 10000);
  await experience.approve(recipient.address, 10);
  await experience.approve(recipient.address, 0);
  await expect(experience.approve(recipient.address, 20))
    .to.not.be.reverted;
});

it('should revert if sender does not have enough balance for transfer', async function () {
  // Asegúrate de que el owner no tenga suficientes tokens
  await expect(experience.safeTransfer(recipient.address, 100000000))
    .to.be.revertedWith("Insufficient balance");
});

it('should revert if sender does not have enough balance for approval', async function () {
  // Asegúrate de que el owner no tenga suficientes tokens
  await expect(experience.approve(recipient.address, 1000000000))
    .to.be.revertedWith("Insufficient balance");
});

});
