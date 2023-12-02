// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import {CCIPReceiver} from "@chainlink/contracts-ccip/src/v0.8/ccip/applications/CCIPReceiver.sol";
import {Client} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";

contract ZetaCCIPReceiver is CCIPReceiver, ReentrancyGuard {
    event FundsTransferred(address indexed recipient, uint256 indexed amount);

    constructor(address router) CCIPReceiver(router) {}

    function _ccipReceive(Client.Any2EVMMessage memory message) internal override nonReentrant {
        (address userAddress, uint256 userAmount) = abi.decode(message.data, (address, uint256));

        require(userAddress != address(0), "Invalid recipient address");
        require(userAmount <= address(this).balance, "Smart contract does not have enough balance");

        (bool success, ) = userAddress.call{value: userAmount}("");
        require(success, "Transfer failed");

        emit FundsTransferred(userAddress, userAmount);
    }

    // Function to allow the contract to receive ether
    receive() external payable {}
}
