// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import {Client} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";
import {IRouterClient} from "@chainlink/contracts-ccip/src/v0.8/ccip/interfaces/IRouterClient.sol";
import {LinkTokenInterface} from "@chainlink/contracts/src/v0.8/shared/interfaces/LinkTokenInterface.sol";

contract ZetaCCIPSender {
    AggregatorV3Interface internal priceFeed;

    event AvaxReceived(
        address indexed sender,
        uint256 indexed tokenAmount,
        uint256 indexed timestamp
    );
    event AvaxPriceInUSD(
        address indexed sender,
        uint256 indexed price,
        uint256 indexed timestamp
    );
    event AmountSentInUSD(
        address indexed sender,
        uint256 indexed amountSent,
        uint256 indexed timestamp
    );
    event FundsWithdrawn(
        address indexed withdrawnBy,
        uint indexed amount,
        uint256 indexed timestamp
    );

    event ConfigurationChanged(
        string indexed config,
        address indexed oldValue,
        address indexed newValue,
        uint256 timestamp
    );
    event ChainSelectorChanged(
        uint64 indexed oldSelector,
        uint64 indexed newSelector,
        uint256 indexed timestamp
    );

    address public constant AvaxUsdAddress =
        0x5498BB86BC934c8D34FDA08E81D444153d0D06aD;
    address link;
    address router;
    address receiver;
    uint64 destinationChainSelector;

    using Strings for address;
    using Strings for uint;

    constructor(
        address _receiver,
        address _link,
        address _router,
        uint64 _destinationChainSelector
    ) {
        // _receiver Smart Contract receiver address
        // _link CCIP link address
        // _router CCIP router address
        // _destinationChainSelector CCIP testnet chain selector
        link = _link;
        router = _router;
        receiver = _receiver;
        destinationChainSelector = _destinationChainSelector;
        priceFeed = AggregatorV3Interface(AvaxUsdAddress);
        LinkTokenInterface(link).approve(router, type(uint256).max);
    }

    // The receive function to handle receiving Ether
    receive() external payable {
        handleIncomingToken(msg.sender, msg.value);
    }

    function handleIncomingToken(address sender, uint amount) internal {
        emit AvaxReceived(sender, amount, block.timestamp);
        uint avaxUsdPrice = uint(getPrice());
        emit AvaxPriceInUSD(sender, avaxUsdPrice, block.timestamp);
        uint amountToTransfer = amount * avaxUsdPrice;
        emit AmountSentInUSD(sender, amountToTransfer, block.timestamp);

        bytes memory messageContent = abi.encode(sender, amountToTransfer);
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
    function withdrawFunds() external {
        uint balance = address(this).balance;
        require(
            balance > 0,
            "The smart contract does not have enough founds to withdraw"
        );

        // Transfer all the funds to the owner's address
        (bool success, ) = msg.sender.call{value: balance}("");
        require(success, "Send ");

        emit FundsWithdrawn(msg.sender, balance, block.timestamp);
    }

    // Function to update contract configurations, accessible only by the owner
    function updateConfiguration(
        string memory config,
        address newValue
    ) external {
        if (keccak256(bytes(config)) == keccak256(bytes("link"))) {
            emit ConfigurationChanged(config, link, newValue, block.timestamp);
            link = newValue;
        } else if (keccak256(bytes(config)) == keccak256(bytes("router"))) {
            emit ConfigurationChanged(
                config,
                router,
                newValue,
                block.timestamp
            );
            router = newValue;
        } else if (
            keccak256(bytes(config)) == keccak256(bytes("msgReceiver"))
        ) {
            emit ConfigurationChanged(
                config,
                receiver,
                newValue,
                block.timestamp
            );
            receiver = newValue;
        }
    }

    // Function to update destination chain selector, accessible only by the owner
    function updateDestinationChainSelector(uint64 newSelector) external {
        emit ChainSelectorChanged(
            destinationChainSelector,
            newSelector,
            block.timestamp
        );
        destinationChainSelector = newSelector;
    }

    function getPrice() internal view returns (int) {
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
