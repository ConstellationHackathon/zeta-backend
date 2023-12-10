import {
  assert,
  describe,
  test,
  clearStore,
  beforeAll,
  afterAll
} from "matchstick-as/assembly/index"
import { Address, Bytes, BigInt } from "@graphprotocol/graph-ts"
import { AmountSentInUSD } from "../generated/schema"
import { AmountSentInUSD as AmountSentInUSDEvent } from "../generated/Contract/Contract"
import { handleAmountSentInUSD } from "../src/contract"
import { createAmountSentInUSDEvent } from "./contract-utils"

// Tests structure (matchstick-as >=0.5.0)
// https://thegraph.com/docs/en/developer/matchstick/#tests-structure-0-5-0

describe("Describe entity assertions", () => {
  beforeAll(() => {
    let sender = Address.fromString(
      "0x0000000000000000000000000000000000000001"
    )
    let transactionId = Bytes.fromI32(1234567890)
    let amountSent = BigInt.fromI32(234)
    let timestamp = BigInt.fromI32(234)
    let newAmountSentInUSDEvent = createAmountSentInUSDEvent(
      sender,
      transactionId,
      amountSent,
      timestamp
    )
    handleAmountSentInUSD(newAmountSentInUSDEvent)
  })

  afterAll(() => {
    clearStore()
  })

  // For more test scenarios, see:
  // https://thegraph.com/docs/en/developer/matchstick/#write-a-unit-test

  test("AmountSentInUSD created and stored", () => {
    assert.entityCount("AmountSentInUSD", 1)

    // 0xa16081f360e3847006db660bae1c6d1b2e17ec2a is the default address used in newMockEvent() function
    assert.fieldEquals(
      "AmountSentInUSD",
      "0xa16081f360e3847006db660bae1c6d1b2e17ec2a-1",
      "sender",
      "0x0000000000000000000000000000000000000001"
    )
    assert.fieldEquals(
      "AmountSentInUSD",
      "0xa16081f360e3847006db660bae1c6d1b2e17ec2a-1",
      "transactionId",
      "1234567890"
    )
    assert.fieldEquals(
      "AmountSentInUSD",
      "0xa16081f360e3847006db660bae1c6d1b2e17ec2a-1",
      "amountSent",
      "234"
    )
    assert.fieldEquals(
      "AmountSentInUSD",
      "0xa16081f360e3847006db660bae1c6d1b2e17ec2a-1",
      "timestamp",
      "234"
    )

    // More assert options:
    // https://thegraph.com/docs/en/developer/matchstick/#asserts
  })
})
