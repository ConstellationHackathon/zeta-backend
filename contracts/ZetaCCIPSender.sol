// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import {Client} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";
import {IRouterClient} from "@chainlink/contracts-ccip/src/v0.8/ccip/interfaces/IRouterClient.sol";
import {LinkTokenInterface} from "@chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol";

contract ZetaAvaCCIPSender  {
    event TokenReceived(address sender, uint amount);
    event FundsWithdrawn(address withdrawnBy, uint amount);
    event ConfigurationChanged(string config, address oldValue, address newValue);
    event ChainSelectorChanged(uint64 oldSelector, uint64 newSelector);

    using Strings for address;
    using Strings for uint;

    address link;
    address router;
    address receiver;
    uint64 destinationChainSelector;

    constructor(address  _receiver, address _link, address _router, uint64 _destinationChainSelector) {
        // _receiver Smart Contract receiver address
        // _link CCIP link address
        // _router CCIP router address
        // _destinationChainSelector CCIP testnet chain selector
        link = _link;
        router = _router;
        receiver = _receiver;
        destinationChainSelector = _destinationChainSelector;
        LinkTokenInterface(link).approve(router, type(uint256).max);
    }

    // The receive function to handle receiving Ether
    receive() external payable {
        emit TokenReceived(msg.sender, msg.value);

        // Call another function upon receiving Ether
        handleIncomingToken(msg.sender, msg.value);
    }


    function handleIncomingToken(address sender, uint amount) internal {
        bytes memory messageContent = abi.encode(sender, amount);

        Client.EVM2AnyMessage memory message = Client.EVM2AnyMessage({
            receiver: abi.encode(receiver),
            data: messageContent,
            tokenAmounts: new Client.EVMTokenAmount[](0),
            extraArgs: "",
            feeToken: link
        });
        IRouterClient(router).ccipSend(destinationChainSelector, message);
    }

    // Function to withdraw the funds from the contract, accessible only by the owner
    function withdrawFunds() external  {
        uint balance = address(this).balance;
        require(balance > 0, "The smart contract does not have enough founds to withdraw");

        // Transfer all the funds to the owner's address
        (bool success, ) = msg.sender.call{value: balance}("");
        require(success, "Send ");

        emit FundsWithdrawn(msg.sender, balance);
    }

    // Function to update contract configurations, accessible only by the owner
        function updateConfiguration(string memory config, address newValue) external  {
            if (keccak256(bytes(config)) == keccak256(bytes("link"))) {
                emit ConfigurationChanged(config, link, newValue);
                link = newValue;
            } else if (keccak256(bytes(config)) == keccak256(bytes("router"))) {
                emit ConfigurationChanged(config, router, newValue);
                router = newValue;
            } else if (keccak256(bytes(config)) == keccak256(bytes("msgReceiver"))) {
                emit ConfigurationChanged(config, receiver, newValue);
                receiver = newValue;
            } 
        }

    // Function to update destination chain selector, accessible only by the owner
    function updateDestinationChainSelector(uint64 newSelector) external {
        emit ChainSelectorChanged(destinationChainSelector, newSelector);
        destinationChainSelector = newSelector;
    }
}
