import console from "console"
const hre = require("hardhat")

// Define the NFT
const receiverContractAddress = "0x95c047c979c94687125a14e706853109d1d4dd3c"
const routerAddress: string = "0x554472a2720e5e7d5d3c817529aba05eed5f82d8"
const ccipLinkAddress: string = "0x0b9d5D9136855f6FEc3c0993feE6E9CE8a297846"
const destinationChainSelector: string = "16015286601757825753"

import { FUJI_CONTRACT_ADDRESS } from "../.env.json"

async function main() {
  await hre.run("verify:verify", {
    address: FUJI_CONTRACT_ADDRESS,
    constructorArguments: [receiverContractAddress, ccipLinkAddress, routerAddress, destinationChainSelector],
  })
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })
