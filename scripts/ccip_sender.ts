import { 
  Contract, 
  ContractFactory 
} from "ethers"
import { ethers } from "hardhat"

const routerAddress: string = "0x554472a2720e5e7d5d3c817529aba05eed5f82d8"
const ccipLinkAddress: string = "0x0b9d5D9136855f6FEc3c0993feE6E9CE8a297846"
const destinationChainSelector: string = "16015286601757825753"
const contractName: string = "ZetaCCIPSender"


import { SEPOLIA_CONTRACT_ADDRESS } from "../.env.json"

const main = async(): Promise<any> => {
  const contractFactory: ContractFactory = await ethers.getContractFactory(contractName)
  const contract: Contract = await contractFactory.deploy(SEPOLIA_CONTRACT_ADDRESS, ccipLinkAddress, routerAddress, destinationChainSelector)

  await contract.deployed()
  console.log(`Zeta fuji deployed to: ${contract.address}`)
}

main()
.then(() => process.exit(0))
.catch(error => {
  console.error(error)
  process.exit(1)
})
