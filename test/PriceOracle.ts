import { ethers } from "hardhat";
import { PriceOracle } from "../typechain";
import { WrapperBuilder } from "redstone-evm-connector";
import { assert } from "chai";
import { BigNumber } from "ethers";

describe("PriceOracle feeds", async () => {

    // CONSTANTS
    let priceOracleContract: PriceOracle;

    // BEFORE HOOK
    before(async () => {
        const priceOracleContractFactory = await ethers.getContractFactory("PriceOracle");
        priceOracleContract = await priceOracleContractFactory.deploy();
        await priceOracleContract.deployed();
        priceOracleContract = WrapperBuilder
            .wrapLite(priceOracleContract)
            .usingPriceFeed("redstone", { asset: "ETH" });
    });

    // TESTS
    it("PriceOracle should return price feeds correctly", async () => {
        const ethPrice = await priceOracleContract.getPrice("ETH");
        assert.isTrue(BigNumber.isBigNumber(ethPrice), "ETH Price came incorrect!");
        console.log(`ETH PRICE: ${ethPrice.toNumber() / 10 ** 8}`);
    });

});