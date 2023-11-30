const { ethers } = require('hardhat');

async function main() {
  await deployContracts();
}

async function deployContracts() {
  const ownersContractAddress = await deployContract('OwnersContract', [1]);

  await deployAndRegisterContract('Experience', [
    'Experience',
    'EXP',
    ownersContractAddress,
  ], ownersContractAddress);

  await deployAndRegisterContract('Rubie', ['Rubie', 'RUB', ownersContractAddress], ownersContractAddress);

  const charactersContractAddress = await deployAndRegisterContract('Character', [
    'Character',
    'CHR',
    'crypto.character.com',
    ownersContractAddress,
  ], ownersContractAddress);

  await deployAndRegisterContract('Weapon', [
    'Weapon',
    'WPN',
    'crypto.weapon.com',
    ownersContractAddress,
    charactersContractAddress,
  ], ownersContractAddress);
}

async function deployAndRegisterContract(contractName, constructorArguments, ownersContractAddress) {
  const contractAddress = await deployContract(contractName, constructorArguments);

  await interactWithOwnersContract(ownersContractAddress, contractName, contractAddress);

  return contractAddress;
}

async function interactWithOwnersContract(ownersContractAddress, contractName, contractAddress) {
  const ownersContract = await ethers.getContractAt('OwnersContract', ownersContractAddress);
  await ownersContract.addContract(contractName, contractAddress);
}
  

async function deployContract(contractName, constructorArguments) {
  const Contract = await ethers.getContractFactory(contractName);
  const deployedContract = await Contract.deploy(...constructorArguments);
  await deployedContract.deployed();

  console.log(`${contractName} deployed to: ${deployedContract.address}`);

  return deployedContract.address;
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
