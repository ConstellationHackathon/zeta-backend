// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {CCIPReceiver} from "@chainlink/contracts-ccip/src/v0.8/ccip/applications/CCIPReceiver.sol";
import {Client} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";

contract ZetaCCIPReceiver is CCIPReceiver, ReentrancyGuard, Ownable {
    AggregatorV3Interface internal priceFeed;

    event MsgReceived(
        address indexed userAddress,
        bytes32 indexed transactionId,
        uint256 indexed amountToTransferUSD,
        uint256 timestamp
    );
    event ETHToSend(
        address indexed userAddress,
        bytes32 indexed transactionId,
        uint256 indexed amountToTransferUSD,
        uint256 timestamp
    );
    event FundsTransferred(
        address indexed recipient,
        bytes32 indexed transactionId,
        uint256 indexed amount,
        uint256 timestamp
    );
    event FundsWithdrawn(
        address indexed withdrawnBy,
        uint indexed amount,
        uint256 indexed timestamp
    );

    event ConfigurationChanged(
        string             indexed config,
        address indexed oldValue,
        address indexed newValue,
        uint256 timestamp
    );

    address public EthUsdAddress = 0x694AA1769357215DE4FAC081bf1f309aDC325306;

    constructor(address router) CCIPReceiver(router) Ownable(msg.sender) {
        priceFeed = AggregatorV3Interface(EthUsdAddress);
    }

    function _ccipReceive(
        Client.Any2EVMMessage memory message
    ) internal override {
        uint EthUsdPrice = uint(getPrice());
        (address userAddress, uint256 userAmount, bytes32 transactionId) = abi.decode(
            message.data,
            (address, uint256, bytes32)
        );
        emit MsgReceived(userAddress, transactionId, userAmount, block.timestamp);
        uint amountToTransfer = userAmount / EthUsdPrice;
        uint fee = amountToTransfer / 100;
        amountToTransfer -= fee;
        require(userAddress != address(0), "Invalid recipient address");
        require(
            amountToTransfer <= address(this).balance,
            "Smart contract does not have enough balance"
        );
        emit ETHToSend(userAddress, transactionId, amountToTransfer, block.timestamp);
        (bool success, ) = userAddress.call{value: amountToTransfer}("");
        require(success, "Transfer failed");
        emit FundsTransferred(userAddress, transactionId, amountToTransfer, block.timestamp);
    }

    // Function to allow the contract to receive ether
    receive() external payable {}

    function getPrice() public view returns (int) {
        (
            uint80 roundID,
            int price,
            uint startedAt,
            uint timeStamp,
            uint80 answeredInRound
        ) = priceFeed.latestRoundData();
        // for ETH / USD price is scaled up by 10 ** 8
        return price / 1e8;
    }

    function getContractBalance() external view returns (uint) {
        return address(this).balance;
    }
    function updateEthUsdAddress(address newAddress) external onlyOwner {
        EthUsdAddress = newAddress;
        priceFeed = AggregatorV3Interface(EthUsdAddress);
        emit ConfigurationChanged(
            "ETHUsdAddress",
            EthUsdAddress,
            newAddress,
            block.timestamp
        );
    }
    function withdrawFunds() external onlyOwner {
        uint balance = address(this).balance;
        require(
            balance > 0,
            "The smart contract does not have enough founds to withdraw"
        );

        (bool success, ) = msg.sender.call{value: balance}("");
        require(success, "Send ");

        emit FundsWithdrawn(msg.sender, balance, block.timestamp);
    }
}

interface AggregatorV3Interface {
    function latestRoundData()
        external
        view
        returns (
            uint80 roundId,
            int answer,
            uint startedAt,
            uint updatedAt,
            uint80 answeredInRound
        );
}
