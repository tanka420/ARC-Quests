const hre = require("hardhat");

async function main() {
  const TAN_TOKEN = "0x570D2fA99996a59af5e29270e6059383216Fe37a"; // Địa chỉ Token TAN cũ của bạn

  console.log("🛠️ Deploying ArcQuest V2 (Logic 24h)...");
  const Quest = await hre.ethers.getContractFactory("ArcQuestV2");
  const quest = await Quest.deploy(TAN_TOKEN);
  await quest.waitForDeployment();

  console.log("✅ ArcQuest V2 Ready at:", await quest.getAddress());
  console.log("⚠️ Nhớ gửi Token TAN vào địa chỉ mới này để làm quỹ thưởng!");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});