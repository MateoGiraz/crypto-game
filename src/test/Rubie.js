// SPDX-License-Identifier: MIT
const { expect } = require('chai');
const { ethers } = require('hardhat');

describe('Rubie', function () {
  let rubie;
  let ownersContract;
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
  });

  it('should have correct initial values', async function () {
    const maxInteger = ethers.constants.MaxUint256;

    expect(await rubie.name()).to.equal('Rubie');
    expect(await rubie.symbol()).to.equal('RBE');
    expect((await rubie.decimals()).toNumber()).to.equal(18);
    expect((await rubie.totalSupply()).toNumber()).to.equal(0);
    expect((await rubie.price()).toString()).to.equal(maxInteger.toString());
  });
  
  it('should allow minting by owner', async function () {
    const initialBalance = await rubie.balanceOf(recipient.address);

    await rubie.connect(owner).mint(100, recipient.address);

    const finalBalance = await rubie.balanceOf(recipient.address);
    expect(finalBalance.sub(initialBalance).toNumber()).to.equal(100);
  });

  it('should allow setting token price', async function () {
    await rubie.setPrice(1);
    const price = await rubie.price();

    expect(price.toNumber()).to.equal(1);
  });

  it('should allow buying tokens', async function () {
    await rubie.connect(owner).mint(10, owner.address);
    const initialBalance = await rubie.balanceOf(owner.address);
    await rubie.setPrice(1);
    const price = await rubie.price();

    const tokensToBuy = 10

    await rubie.buy(tokensToBuy, { value: price * tokensToBuy });

    const finalBalance = await rubie.balanceOf(owner.address);
    expect(finalBalance - initialBalance).to.equal(tokensToBuy);
  });

  it('should allow transferring tokens', async function () {
    await rubie.connect(owner).mint(100, owner.address);
    
    const initialSenderBalance = await rubie.balanceOf(owner.address);
    const initialRecipientBalance = await rubie.balanceOf(recipient.address);

    await rubie.safeTransfer(recipient.address, 50);

    const finalSenderBalance = await rubie.balanceOf(owner.address);
    const finalRecipientBalance = await rubie.balanceOf(recipient.address);

    expect(finalSenderBalance - initialSenderBalance).to.equal(-50);
    expect(finalRecipientBalance - initialRecipientBalance).to.equal(50);
  });

});
