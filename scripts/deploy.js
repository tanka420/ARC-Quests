const hre = require("hardhat");

async function main() {
  console.log("----------------------------------------------------");
  console.log("🚀 Đang bắt đầu phát hành Token TAN...");

  const [deployer] = await hre.ethers.getSigners();
  console.log("👤 Chủ sở hữu (Deployer):", deployer.address);

  // 1. Lấy Contract Factory (Phải đúng tên class trong file .sol là "TAN")
  const Token = await hre.ethers.getContractFactory("TAN");

  // 2. Tính toán số lượng Token
  // Bạn muốn phát hành 1 triệu Token?
  // Hàm parseEther sẽ tự động thêm 18 số 0 vào sau số 1,000,000
  const amount = hre.ethers.parseEther("1000000"); 

  console.log("💰 Đang mint 1,000,000 TAN...");

  // 3. Deploy và truyền tham số vào Constructor
  const token = await Token.deploy(amount);

  // 4. Chờ mạng xác nhận (Quan trọng cho Hardhat v6)
  await token.waitForDeployment();

  console.log("----------------------------------------------------");
  console.log("✅ DEPLOY THÀNH CÔNG!");
  console.log("📍 Địa chỉ Token TAN:", await token.getAddress());
  console.log("----------------------------------------------------");
  console.log(`🌍 Xem trên Explorer: https://testnet.arcscan.app/address/${await token.getAddress()}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});