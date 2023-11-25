// SPDX-License-Identifier: MIT
const { expect } = require('chai');
const { ethers } = require('hardhat');

describe('Experience', function () {
  let experience;
  let ownersContract;
  let rubie;
  let owner;
  let recipient;

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

    await ownersContract.addContract('Rubie', rubie.address);
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
});
