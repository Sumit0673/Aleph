// import { HardhatUserConfig } from "hardhat/config";
// import "@nomicfoundation/hardhat-toolbox";

// const config: HardhatUserConfig = {
//   solidity: "0.8.28",
// };

// export default config;
import "@nomicfoundation/hardhat-toolbox";

module.exports = {
  solidity: "0.8.28", // Ensure this matches your Lock.sol version
  paths: {
    artifacts: "./artifacts",
    sources: "./contracts",
    cache: "./cache",
  },
  networks: {
    hardhat: {},
  },
};
