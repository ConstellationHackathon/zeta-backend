// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

//import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";


// 0x5498BB86BC934c8D34FDA08E81D444153d0D06aD Avax/Usd Fuji 
// 0x694AA1769357215DE4FAC081bf1f309aDC325306 Eth/Usd Sepolia

contract ZetaChainLinkOraclePrice {
    AggregatorV3Interface internal priceFeed;

    constructor(address feedPricesAddress) {
        // ETH / USD
        priceFeed = AggregatorV3Interface(feedPricesAddress);
    }

    function getLatestPrice() public view returns (int) {
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
