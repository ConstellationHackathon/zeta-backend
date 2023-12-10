import { newMockEvent } from "matchstick-as"
import { ethereum, Address, Bytes, BigInt } from "@graphprotocol/graph-ts"
import {
  AmountSentInUSD,
  AvaxPriceInUSD,
  AvaxReceived,
  ChainSelectorChanged,
  ConfigurationChanged,
  FundsWithdrawn,
  OwnershipTransferred
} from "../generated/Contract/Contract"

export function createAmountSentInUSDEvent(
  sender: Address,
  transactionId: Bytes,
  amountSent: BigInt,
  timestamp: BigInt
): AmountSentInUSD {
  let amountSentInUsdEvent = changetype<AmountSentInUSD>(newMockEvent())

  amountSentInUsdEvent.parameters = new Array()

  amountSentInUsdEvent.parameters.push(
    new ethereum.EventParam("sender", ethereum.Value.fromAddress(sender))
  )
  amountSentInUsdEvent.parameters.push(
    new ethereum.EventParam(
      "transactionId",
      ethereum.Value.fromFixedBytes(transactionId)
    )
  )
  amountSentInUsdEvent.parameters.push(
    new ethereum.EventParam(
      "amountSent",
      ethereum.Value.fromUnsignedBigInt(amountSent)
    )
  )
  amountSentInUsdEvent.parameters.push(
    new ethereum.EventParam(
      "timestamp",
      ethereum.Value.fromUnsignedBigInt(timestamp)
    )
  )

  return amountSentInUsdEvent
}

export function createAvaxPriceInUSDEvent(
  sender: Address,
  transactionId: Bytes,
  price: BigInt,
  timestamp: BigInt
): AvaxPriceInUSD {
  let avaxPriceInUsdEvent = changetype<AvaxPriceInUSD>(newMockEvent())

  avaxPriceInUsdEvent.parameters = new Array()

  avaxPriceInUsdEvent.parameters.push(
    new ethereum.EventParam("sender", ethereum.Value.fromAddress(sender))
  )
  avaxPriceInUsdEvent.parameters.push(
    new ethereum.EventParam(
      "transactionId",
      ethereum.Value.fromFixedBytes(transactionId)
    )
  )
  avaxPriceInUsdEvent.parameters.push(
    new ethereum.EventParam("price", ethereum.Value.fromUnsignedBigInt(price))
  )
  avaxPriceInUsdEvent.parameters.push(
    new ethereum.EventParam(
      "timestamp",
      ethereum.Value.fromUnsignedBigInt(timestamp)
    )
  )

  return avaxPriceInUsdEvent
}

export function createAvaxReceivedEvent(
  sender: Address,
  transactionId: Bytes,
  tokenAmount: BigInt,
  timestamp: BigInt
): AvaxReceived {
  let avaxReceivedEvent = changetype<AvaxReceived>(newMockEvent())

  avaxReceivedEvent.parameters = new Array()

  avaxReceivedEvent.parameters.push(
    new ethereum.EventParam("sender", ethereum.Value.fromAddress(sender))
  )
  avaxReceivedEvent.parameters.push(
    new ethereum.EventParam(
      "transactionId",
      ethereum.Value.fromFixedBytes(transactionId)
    )
  )
  avaxReceivedEvent.parameters.push(
    new ethereum.EventParam(
      "tokenAmount",
      ethereum.Value.fromUnsignedBigInt(tokenAmount)
    )
  )
  avaxReceivedEvent.parameters.push(
    new ethereum.EventParam(
      "timestamp",
      ethereum.Value.fromUnsignedBigInt(timestamp)
    )
  )

  return avaxReceivedEvent
}

export function createChainSelectorChangedEvent(
  oldSelector: BigInt,
  newSelector: BigInt,
  timestamp: BigInt
): ChainSelectorChanged {
  let chainSelectorChangedEvent = changetype<ChainSelectorChanged>(
    newMockEvent()
  )

  chainSelectorChangedEvent.parameters = new Array()

  chainSelectorChangedEvent.parameters.push(
    new ethereum.EventParam(
      "oldSelector",
      ethereum.Value.fromUnsignedBigInt(oldSelector)
    )
  )
  chainSelectorChangedEvent.parameters.push(
    new ethereum.EventParam(
      "newSelector",
      ethereum.Value.fromUnsignedBigInt(newSelector)
    )
  )
  chainSelectorChangedEvent.parameters.push(
    new ethereum.EventParam(
      "timestamp",
      ethereum.Value.fromUnsignedBigInt(timestamp)
    )
  )

  return chainSelectorChangedEvent
}

export function createConfigurationChangedEvent(
  config: string,
  oldValue: Address,
  newValue: Address,
  timestamp: BigInt
): ConfigurationChanged {
  let configurationChangedEvent = changetype<ConfigurationChanged>(
    newMockEvent()
  )

  configurationChangedEvent.parameters = new Array()

  configurationChangedEvent.parameters.push(
    new ethereum.EventParam("config", ethereum.Value.fromString(config))
  )
  configurationChangedEvent.parameters.push(
    new ethereum.EventParam("oldValue", ethereum.Value.fromAddress(oldValue))
  )
  configurationChangedEvent.parameters.push(
    new ethereum.EventParam("newValue", ethereum.Value.fromAddress(newValue))
  )
  configurationChangedEvent.parameters.push(
    new ethereum.EventParam(
      "timestamp",
      ethereum.Value.fromUnsignedBigInt(timestamp)
    )
  )

  return configurationChangedEvent
}

export function createFundsWithdrawnEvent(
  withdrawnBy: Address,
  amount: BigInt,
  timestamp: BigInt
): FundsWithdrawn {
  let fundsWithdrawnEvent = changetype<FundsWithdrawn>(newMockEvent())

  fundsWithdrawnEvent.parameters = new Array()

  fundsWithdrawnEvent.parameters.push(
    new ethereum.EventParam(
      "withdrawnBy",
      ethereum.Value.fromAddress(withdrawnBy)
    )
  )
  fundsWithdrawnEvent.parameters.push(
    new ethereum.EventParam("amount", ethereum.Value.fromUnsignedBigInt(amount))
  )
  fundsWithdrawnEvent.parameters.push(
    new ethereum.EventParam(
      "timestamp",
      ethereum.Value.fromUnsignedBigInt(timestamp)
    )
  )

  return fundsWithdrawnEvent
}

export function createOwnershipTransferredEvent(
  previousOwner: Address,
  newOwner: Address
): OwnershipTransferred {
  let ownershipTransferredEvent = changetype<OwnershipTransferred>(
    newMockEvent()
  )

  ownershipTransferredEvent.parameters = new Array()

  ownershipTransferredEvent.parameters.push(
    new ethereum.EventParam(
      "previousOwner",
      ethereum.Value.fromAddress(previousOwner)
    )
  )
  ownershipTransferredEvent.parameters.push(
    new ethereum.EventParam("newOwner", ethereum.Value.fromAddress(newOwner))
  )

  return ownershipTransferredEvent
}
