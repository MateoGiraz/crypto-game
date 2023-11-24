const { ethers } = require('hardhat')

async function main() {
  await deployContracts()
}

async function deployContracts() {
  const ownersContractAddress = await deployContract('OwnersContract', [1])
  await deployContract('Experience', [
    'Experience',
    'EXP',
    ownersContractAddress,
  ])
  //await deployContract('Character', [])
  await deployContract('Rubie', ['Rubie', 'RUB', ownersContractAddress])
  await deployContract('Weapon', [])
}

async function deployContract(contractName, constructorArguments) {
  const Contract = await ethers.getContractFactory(contractName)
  const deployedContract = await Contract.deploy(...constructorArguments)
  await deployedContract.deployed()

  console.log(`${contractName} deployed to: ${deployedContract.address}`)

  return deployedContract.address
}

main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
