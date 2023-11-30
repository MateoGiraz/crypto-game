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
        expect(await weapon.name()).to.equal('Weapon'); // Replace 'WeaponCollection' with the expected name
        expect(await weapon.symbol()).to.equal('WPN'); // Replace 'WPN' with the expected symbol
        expect(await weapon.tokenURI()).to.equal('tokenURI'); // Replace 'tokenURI' with the expected tokenURI
        expect((await weapon.totalSupply()).toNumber()).to.equal(0);
    });

    it('should return the correct balance for the owner', async function () {
        
        expect((await weapon.balanceOf(owner.address)).toNumber()).to.equal(0);
        
        
        // Mint a new weapon to the owner
        const weaponName = 'Sword of Power'; // Replace with the desired weapon name
        await weapon.safeMint(weaponName);
    
        // Verify that the balance of the owner is now 1
        expect((await weapon.balanceOf(owner.address)).toNumber()).to.equal(1);
        
        // Mint another weapon to the owner
        const secondWeaponName = 'Axe of Destruction'; // Replace with another desired weapon name
        await weapon.safeMint(secondWeaponName);
    
        // Verify that the balance of the owner is now 2
        expect((await weapon.balanceOf(owner.address)).toNumber()).to.equal(2);
      });
    
      it('should return 0 for the balance of an address with no tokens', async function () {
        // Verify that the balance of a recipient with no tokens is 0
        expect((await weapon.balanceOf(recipient.address)).toNumber()).to.equal(0);
      });

      it('should return the correct balance for the owner after a transfer', async function () {
        // Mint a new weapon to the owner
        const weaponName = 'Sword of Power'; // Replace with the desired weapon name
        await weapon.safeMint(weaponName);
        const weaponId = weapon.totalSupply();
        await weapon.safeTransferFrom(owner.address, recipient.address, weaponId);
        // Verify that the balance of the owner is now 1
        const ownerBalance = await weapon.balanceOf(owner.address);
        expect((await weapon.balanceOf(recipient.address)).toNumber()).to.equal(1);
        
      });
});