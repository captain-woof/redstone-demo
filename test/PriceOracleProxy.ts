import { ethers } from "hardhat";
import { ContractA, ContractB } from "../typechain";
import { WrapperBuilder } from "redstone-evm-connector";
import { assert } from "chai";
import { BigNumber } from "ethers";

describe("PriceOracle feeds", async () => {

    // CONSTANTS
    let aContract: ContractA;
    let bContract: ContractB;

    // BEFORE HOOK
    before(async () => {
        const bContractFactory = await ethers.getContractFactory("ContractB");
        bContract = await bContractFactory.deploy();
        await bContract.deployed();

        const aContractFactory = await ethers.getContractFactory("ContractA");
        aContract = await aContractFactory.deploy(bContract.address);
        await aContract.deployed();
        aContract = WrapperBuilder
            .wrapLite(aContract)
            .usingPriceFeed("redstone", { asset: "ETH" });
    });

    // TESTS
    it("PriceOracle should return price feeds correctly", async () => {
        await aContract.readFromContractBAndSave();
        const ethPrice = await aContract.getLastValueFromContractB();
        assert.isTrue(BigNumber.isBigNumber(ethPrice), "ETH Price came incorrect!");
        console.log(`ETH PRICE: ${ethPrice.toNumber() / 10 ** 8}`);
    });

});