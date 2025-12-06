const hre = require("hardhat");

async function main() {
  // Địa chỉ Token TAN cũ của bạn (để phát thưởng GM)
  const TAN_TOKEN = "0x570D2fA99996a59af5e29270e6059383216Fe37a"; 

  console.log("--------------------------------------------------");
  console.log("🛠️  Deploying ArcQuest NATIVE (USDC Payable)...");
  
  const Quest = await hre.ethers.getContractFactory("ArcQuestV3_Native");
  const quest = await Quest.deploy(TAN_TOKEN);
  
  await quest.waitForDeployment();
  
  const address = await quest.getAddress();
  console.log("✅ Contract deployed to:", address);
  console.log("--------------------------------------------------");
  console.log("⚠️  BƯỚC TIẾP THEO QUAN TRỌNG:");
  console.log("1. Copy địa chỉ trên vào file index.html");
  console.log("2. Gửi Token TAN vào địa chỉ này (để làm quỹ thưởng GM)");
  console.log("3. Verify contract bằng lệnh:");
  console.log(`   npx hardhat verify --network arc ${address} "${TAN_TOKEN}"`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});