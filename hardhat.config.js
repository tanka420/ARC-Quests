require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    version: "0.8.28", // Khớp với file TAN.sol của bạn
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
      evmVersion: "paris", 
    },
  },
  networks: {
    arc: { // Tên mạng là 'arc'
      url: process.env.ARC_RPC_URL || "https://rpc.testnet.arc.network",
      accounts: process.env.PRIVATE_KEY ? [process.env.PRIVATE_KEY] : [],
      chainId: 5042002,
    },
  },
  // --- PHẦN MỚI THÊM VÀO ĐỂ VERIFY ---
  etherscan: {
    apiKey: {
      arc: "abc", // Blockscout không bắt buộc key chuẩn, điền bừa cũng được
    },
    customChains: [
      {
        network: "arc", // Phải trùng tên với network bên trên
        chainId: 5042002,
        urls: {
          apiURL: "https://testnet.arcscan.app/api", 
          browserURL: "https://testnet.arcscan.app",
        },
      },
    ],
  },
  sourcify: {
    enabled: false, // Tắt cái này để tránh lỗi xung đột
  },
};