import console from "console"
const hre = require("hardhat")

const routerAddress: string = "0xd0daae2231e9cb96b94c8512223533293c3693bf"

import { SEPOLIA_CONTRACT_ADDRESS } from "../.env.json"

async function main() {
  await hre.run("verify:verify", {
    address: SEPOLIA_CONTRACT_ADDRESS,
    constructorArguments: [routerAddress],
  })
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })
