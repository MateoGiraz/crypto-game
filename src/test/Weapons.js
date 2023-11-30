const { expect } = require('chai')
const { ethers } = require('hardhat')

describe('Weapon', function () {
    let weapon;
    let ownersContract;
    let rubie;
    let owner;
    let experience;
    let character;
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

        await rubie.mint(1, owner.address);

        // Deploy Character
        const Character = await ethers.getContractFactory('Character')
        character = await Character.deploy('Character','CHR','tokenURI',ownersContract.address);
        await character.deployed()

        // Deploy Experience
        const Experience = await ethers.getContractFactory('Experience');
        experience = await Experience.deploy('Experience', 'EXP', ownersContract.address);
        await experience.deployed();

        //Deploy Weapon
        const Weapon = await ethers.getContractFactory('Weapon');
        weapon = await Weapon.deploy('Weapon', 'WPN', 'tokenURI', ownersContract.address, character.address);
        await weapon.deployed();

        await ownersContract.addContract('character', character.address);
        await ownersContract.addContract('Rubie', rubie.address);
        await ownersContract.addContract('Weapon', weapon.address);
        await ownersContract.addContract('Experience', experience.address);
    });

    it('should have correct initial values', async function () {
        expect(await weapon.name()).to.equal('Weapon'); 
        expect(await weapon.symbol()).to.equal('WPN'); 
        expect(await weapon.tokenURI()).to.equal('tokenURI');  
        expect((await weapon.totalSupply()).toNumber()).to.equal(0);
    });

    it('should return the correct balance for the owner', async function () {
        
        expect((await weapon.balanceOf(owner.address)).toNumber()).to.equal(0);
        
        const weaponName = 'Sword of Power'; 
        await weapon.safeMint(weaponName);
     
        expect((await weapon.balanceOf(owner.address)).toNumber()).to.equal(1);
        
        const secondWeaponName = 'Axe of Destruction'; 
        await weapon.safeMint(secondWeaponName);
    
        expect((await weapon.balanceOf(owner.address)).toNumber()).to.equal(2);
      });
    
      it('should return 0 for the balance of an address with no tokens', async function () {
        
        expect((await weapon.balanceOf(recipient.address)).toNumber()).to.equal(0);
      });

      it('should return the correct balance for the owner after a transfer', async function () {
        
        const weaponName = 'Sword of Power'; 
        await weapon.safeMint(weaponName);
        const weaponId = weapon.totalSupply();
        await weapon.safeTransferFrom(owner.address, recipient.address, weaponId);
         
        const ownerBalance = await weapon.balanceOf(owner.address);
        expect((await weapon.balanceOf(recipient.address)).toNumber()).to.equal(1);
        
      });

      it('should not allow transferring a token from an address that is not the owner', async function () {
        const weaponName = 'Sword of Power'; 
        await weapon.safeMint(weaponName);
        const weaponId = weapon.totalSupply();


        await expect(
            weapon.connect(recipient).safeTransferFrom(owner.address, recipient.address, weaponId)
        ).to.be.revertedWith("Not authorized");
    });

    it('should mint a legendary weapon with valid parameters', async function () {
        const attackPoints = 200;
        const armorPoints = 150;
        const sellPrice = 100;
        const requiredExperience = 20;

        await weapon.mintLegendaryWeapon(attackPoints, armorPoints, sellPrice, requiredExperience);

        const tokenId = weapon.totalSupply();
        const metadata = await weapon.metadataOf(tokenId);

        expect(metadata.attackPoints).to.equal(attackPoints);
        expect(metadata.armorPoints).to.equal(armorPoints);
        expect(metadata.sellPrice).to.equal(sellPrice);
        expect(metadata.requiredExperience).to.equal(requiredExperience);
        expect(metadata.onSale).to.equal(true);
    });

    it('should not mint a legendary weapon with invalid parameters', async function () {
        // Attempt to mint a legendary weapon with invalid attackPoints
        await expect(
            weapon.mintLegendaryWeapon(100, 150, 100, 20)
        ).to.be.revertedWith("Invalid _attackPoints");

        // Add more test cases for invalid parameters
    });

    it('should allow the owner to set a weapon on sale', async function () {
        const weaponName = 'Sword of Power';
        await weapon.safeMint(weaponName);
        const tokenId = weapon.totalSupply();

        await weapon.setOnSale(tokenId, true);

        const metadata = await weapon.metadataOf(tokenId);
        expect(metadata.onSale).to.equal(true);
    });

    it('should not allow a non-owner to set a weapon on sale', async function () {
        const weaponName = 'Sword of Power';
        await weapon.safeMint(weaponName);
        const tokenId = weapon.totalSupply();


        await expect(
            weapon.connect(recipient).setOnSale(tokenId, true)
        ).to.be.revertedWith("Not the owner");
    });

    it('should not allow a purchase if the buyer does not have enough Rubies', async function () {
      const weaponName = 'Sword of Power';
      await weapon.safeMint(weaponName);
      const tokenId = weapon.totalSupply();
      const sellPrice = 100;

      await weapon.setOnSale(tokenId, true);

      // Try to buy without enough Rubies
      await expect(
          weapon.buy(tokenId, 'New Sword')
      ).to.be.revertedWith("Not enough Rubies");
  });
/*
    it('should allow a user to buy a weapon', async function () {
        const weaponName = 'Sword of Power';
        await weapon.safeMint(weaponName);
        const tokenId = weapon.totalSupply();
        const sellPrice = 50;

        const initialBalanceOwner = await rubie.balanceOf(owner.address);
        const initialBalanceRecipient = await rubie.balanceOf(recipient.address);
        await rubie.mint(sellPrice, recipient.address);
        await rubie.mint(sellPrice, owner.address);

        await weapon.setOnSale(tokenId, true);

        await expect(weapon.buy(tokenId, 'New Sword'));
        
        const metadata = await weapon.metadataOf(tokenId);

        const finalBalanceOwner = await rubie.balanceOf(owner.address);
        
        const finalBalanceRecipient = await rubie.balanceOf(recipient.address);

        //expect(metadata.onSale).to.equal(false);
        expect(metadata.name).to.equal('New Sword');
        expect(finalBalanceOwner.sub(initialBalanceOwner)).to.equal(sellPrice);
        expect(finalBalanceRecipient.sub(initialBalanceRecipient)).to.equal(0);

    });*/
});