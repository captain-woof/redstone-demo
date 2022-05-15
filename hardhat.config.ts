import * as dotenv from "dotenv";

import { HardhatUserConfig } from "hardhat/config";
import "@nomiclabs/hardhat-etherscan";
import "@nomiclabs/hardhat-waffle";
import "@typechain/hardhat";

dotenv.config();

const config: HardhatUserConfig = {
  solidity: {
    compilers: ["0.6.6", "0.8.2"].map((versionNum) => ({
      version: versionNum,
      settings: {
        optimizer: {
          enabled: true,
          runs: 5000,
          details: {
            yul: false
          }
        },
      }
    }))
  },

};

export default config;
