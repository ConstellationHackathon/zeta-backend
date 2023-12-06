// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {CCIPReceiver} from "@chainlink/contracts-ccip/src/v0.8/ccip/applications/CCIPReceiver.sol";
import {Client} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";

contract ZetaCCIPReceiver is CCIPReceiver, ReentrancyGuard {
    AggregatorV3Interface internal priceFeed;

    event FundsTransferred(address indexed recipient, uint256 indexed amount);
    event LogFound(address userAddress, uint256 amountToTransfer);

    address public EthUsdAddress =
        0x694AA1769357215DE4FAC081bf1f309aDC325306;

    constructor(address router) CCIPReceiver(router) {
        priceFeed = AggregatorV3Interface(EthUsdAddress);
    }

    function _ccipReceive(
        Client.Any2EVMMessage memory message
    ) internal override {
        uint EthUsdPrice = uint(getPrice());
        (address userAddress, uint256 userAmount) = abi.decode(
            message.data,
            (address, uint256)
        );
        emit LogFound(userAddress, userAmount);
        uint amountToTransfer = userAmount / EthUsdPrice;
        emit LogFound(userAddress, amountToTransfer);

        require(userAddress != address(0), "Invalid recipient address");
        require(
            amountToTransfer <= address(this).balance,
            "Smart contract does not have enough balance"
        );

        (bool success, ) = userAddress.call{value: amountToTransfer}("");
        require(success, "Transfer failed");

        emit FundsTransferred(userAddress, amountToTransfer);
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
