import {
  AmountSentInUSD as AmountSentInUSDEvent,
  AvaxPriceInUSD as AvaxPriceInUSDEvent,
  AvaxReceived as AvaxReceivedEvent,
  ChainSelectorChanged as ChainSelectorChangedEvent,
  ConfigurationChanged as ConfigurationChangedEvent,
  FundsWithdrawn as FundsWithdrawnEvent,
  OwnershipTransferred as OwnershipTransferredEvent
} from "../generated/Contract/Contract"
import {
  AmountSentInUSD,
  AvaxPriceInUSD,
  AvaxReceived,
  ChainSelectorChanged,
  ConfigurationChanged,
  FundsWithdrawn,
  OwnershipTransferred
} from "../generated/schema"

export function handleAmountSentInUSD(event: AmountSentInUSDEvent): void {
  let entity = new AmountSentInUSD(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.sender = event.params.sender
  entity.transactionId = event.params.transactionId
  entity.amountSent = event.params.amountSent
  entity.timestamp = event.params.timestamp

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleAvaxPriceInUSD(event: AvaxPriceInUSDEvent): void {
  let entity = new AvaxPriceInUSD(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.sender = event.params.sender
  entity.transactionId = event.params.transactionId
  entity.price = event.params.price
  entity.timestamp = event.params.timestamp

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleAvaxReceived(event: AvaxReceivedEvent): void {
  let entity = new AvaxReceived(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.sender = event.params.sender
  entity.transactionId = event.params.transactionId
  entity.tokenAmount = event.params.tokenAmount
  entity.timestamp = event.params.timestamp

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleChainSelectorChanged(
  event: ChainSelectorChangedEvent
): void {
  let entity = new ChainSelectorChanged(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.oldSelector = event.params.oldSelector
  entity.newSelector = event.params.newSelector
  entity.timestamp = event.params.timestamp

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleConfigurationChanged(
  event: ConfigurationChangedEvent
): void {
  let entity = new ConfigurationChanged(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.config = event.params.config.toHexString()
  entity.oldValue = event.params.oldValue
  entity.newValue = event.params.newValue
  entity.timestamp = event.params.timestamp

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleFundsWithdrawn(event: FundsWithdrawnEvent): void {
  let entity = new FundsWithdrawn(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.withdrawnBy = event.params.withdrawnBy
  entity.amount = event.params.amount
  entity.timestamp = event.params.timestamp

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleOwnershipTransferred(
  event: OwnershipTransferredEvent
): void {
  let entity = new OwnershipTransferred(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.previousOwner = event.params.previousOwner
  entity.newOwner = event.params.newOwner

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}
