const hre = require("hardhat");

async function main() {
  console.log("----------------------------------------------------");
  console.log("⚡ BẮT ĐẦU STRESS TEST MẠNG ARC (SPAM TRANSACTION)");
  console.log("----------------------------------------------------");

  // 1. Kết nối ví
  const [deployer] = await hre.ethers.getSigners();
  console.log("👤 Ví thực hiện:", deployer.address);

  // 2. Kết nối Contract Token của bạn
  // Thay địa chỉ Token của bạn vào đây
  const TOKEN_ADDRESS = "0x570D2fA99996a59af5e29270e6059383216Fe37a"; 
  const Token = await hre.ethers.getContractFactory("TAN");
  const token = Token.attach(TOKEN_ADDRESS);

  // 3. Cấu hình gửi
  const loopCount = 10; // Số lượng giao dịch muốn spam (thử 10 cái trước)
  const amount = hre.ethers.parseEther("1"); // Gửi 1 TAN mỗi lần
  const recipient = deployer.address; // Gửi cho chính mình (để đỡ tốn token, chỉ tốn gas)

  console.log(`🎯 Mục tiêu: Gửi ${loopCount} giao dịch liên tục...`);
  
  let successCount = 0;
  let totalTime = 0;

  for (let i = 1; i <= loopCount; i++) {
    const startTime = Date.now();
    try {
      process.stdout.write(`⏳ Tx ${i}/${loopCount}: Đang gửi... `);
      
      // Gửi transaction
      const tx = await token.transfer(recipient, amount);
      
      // Chờ xác nhận
      await tx.wait();
      
      const endTime = Date.now();
      const duration = (endTime - startTime) / 1000; // Đổi sang giây
      totalTime += duration;
      successCount++;
      
      console.log(`✅ Xong! Hash: ${tx.hash.substring(0, 10)}... | ⏱️ Mất: ${duration}s`);
    } catch (error) {
      console.log(`❌ Lỗi: ${error.message}`);
    }
  }

  console.log("----------------------------------------------------");
  console.log("📊 TỔNG KẾT HIỆU NĂNG ARC:");
  console.log(`✅ Thành công: ${successCount}/${loopCount}`);
  console.log(`⚡ Thời gian trung bình: ${(totalTime / successCount).toFixed(2)} giây/giao dịch`);
  
  if ((totalTime / successCount) < 2) {
    console.log("🚀 ĐÁNH GIÁ: MẠNG RẤT NHANH (Đạt chuẩn < 2s)");
  } else {
    console.log("🐢 ĐÁNH GIÁ: MẠNG CÒN CHẬM");
  }
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});