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

  it('should revert with invalid address for safeTransfer', async () => {
    await rubie.connect(owner).mint(1000, owner.address);
    const ownerBalance = await rubie.balanceOf(owner.address);
    expect(ownerBalance).to.be.at.least(10);
  
    await expect(rubie.connect(owner).safeTransfer("0x0000000000000000000000000000000000000000", 10))
      .to.be.revertedWith("Invalid address");
  });
  
  

  it('should revert with invalid address for approve', async () => {
    await expect(rubie.approve("0x0000000000000000000000000000000000000000", 10))
      .to.be.revertedWith("Invalid _spender");
  });

  it('should revert if non-owner tries to set price', async function () {
    await expect(rubie.connect(recipient).setPrice(10))
      .to.be.revertedWith("Not the owner");
  });

  it('should allow owner to set price', async function () {
    await expect(rubie.connect(owner).setPrice(10))
      .to.not.be.reverted;
    expect(await rubie.price()).to.equal(10);
  });

  it('should revert if trying to set non-zero allowance on top of non-zero allowance', async function () {
    await rubie.connect(owner).mint(100, owner.address);
    await rubie.approve(recipient.address, 10);
    await expect(rubie.approve(recipient.address, 20))
      .to.be.revertedWith("Invalid allowance amount. Set to zero first");
  });

  it('should emit a Transfer event on mint', async function () {
    await expect(rubie.connect(owner).mint(100, recipient.address))
      .to.emit(rubie, 'Transfer').withArgs(ethers.constants.AddressZero, recipient.address, 100);
  });
  
  
  
  

});
