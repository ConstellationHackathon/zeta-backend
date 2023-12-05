import { 
  Contract, 
  ContractFactory 
} from "ethers"
import { ethers } from "hardhat"

const routerAddress: string = "0xd0daae2231e9cb96b94c8512223533293c3693bf"
const contractName: string = "ZetaCCIPReceiver"

const main = async(): Promise<any> => {
  const contractFactory: ContractFactory = await ethers.getContractFactory(contractName)
  const contract: Contract = await contractFactory.deploy(routerAddress)
  await contract.deployed()
  console.log(`Zeta contract deployed to: ${contract.address}`)
}

main()
.then(() => process.exit(0))
.catch(error => {
  console.error(error)
  process.exit(1)
})
