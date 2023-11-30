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

      it('should add a weapon to a character and update stats', async function () {

        await character.mintHero('Hero');
        characterId = await character.tokenId();
        
        const initialWeaponCount = await character.weaponCount(characterId);
        expect(initialWeaponCount.toNumber()).to.equal(0);

        await weapon.addWeaponToCharacter(weaponId, characterId);

        const updatedWeaponCount = await character.weaponCount(characterId);
        expect(updatedWeaponCount).to.equal(1);


        const characterStats = await character.metadataOf(characterId);
        const weaponStats = await weapon.metadataOf(weaponId);

        expect(characterStats.attackPoints).to.equal(weaponStats.attackPoints);
        expect(characterStats.armorPoints).to.equal(weaponStats.armorPoints);
        expect(characterStats.sellPrice).to.equal(weaponStats.sellPrice);
        expect(characterStats.requiredExperience).to.equal(weaponStats.requiredExperience);

        const isEquipped = await characterContract.isEquiped(characterId, weaponId);
        expect(isEquipped).to.be.true;
    });
});