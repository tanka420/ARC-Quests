// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// --- CÁC CONTRACT CON (TEMPLATES) ---
contract BasicBase { address public owner; constructor(address _o) { owner = _o; } }
contract VaultBase { address public owner; constructor(address _o) { owner = _o; } receive() external payable {} }
contract NoteBase { address public owner; string public note; constructor(address _o) { owner = _o; } function setNote(string memory _n) public { note = _n; } }

contract ArcQuestV3_Native {
    IERC20 public rewardToken; // Token TAN (Dùng để thưởng GM)
    
    // Phí dịch vụ: 0.1 USDC (Native Coin)
    // Lưu ý: Trên EVM, đơn vị gốc luôn tính là 18 số 0 (wei)
    uint256 public serviceFee = 0.1 ether; 

    struct UserStats {
        uint256 lastGMTime;       
        uint256 totalGM;          
        uint256 currentStreak;    
        address[] deployedBases;  
    }
    
    mapping(address => UserStats) public users;
    
    event UserGMed(address indexed user, uint256 timestamp, uint256 streak);
    event UserDeployed(address indexed user, address newContractAddress, string typeName);
    event FeeReceived(address indexed user, uint256 amount);

    constructor(address _rewardTokenAddress) {
        rewardToken = IERC20(_rewardTokenAddress);
    }

    // --- GM (Logic cũ - Nhận thưởng TAN) ---
    function gm() public {
        UserStats storage user = users[msg.sender];
        require(block.timestamp >= user.lastGMTime + 1 days, "Cooldown active: Wait 24h.");
        
        // Logic tính Streak
        if (block.timestamp > user.lastGMTime + 2 days && user.lastGMTime != 0) {
            user.currentStreak = 1;
        } else {
            user.currentStreak++;
        }

        user.lastGMTime = block.timestamp;
        user.totalGM++;
        
        // Tính thưởng (Max 50 TAN bonus)
        uint256 bonus = user.currentStreak * 1 ether; 
        if (bonus > 50 ether) bonus = 50 ether; 
        uint256 totalReward = 5 * 10**18 + bonus;

        // Trả thưởng nếu quỹ còn tiền
        if (rewardToken.balanceOf(address(this)) >= totalReward) {
            rewardToken.transfer(msg.sender, totalReward);
        }
        
        emit UserGMed(msg.sender, block.timestamp, user.currentStreak);
    }

    // --- DEPLOY (NATIVE PAYABLE - TỐI ƯU HÓA) ---
    // User gửi thẳng 0.1 USDC vào đây
    function deployBase(uint8 _type) public payable {
        // Kiểm tra tiền gửi vào có đủ 0.1 USDC không
        require(msg.value >= serviceFee, "Insufficient Fee! Send 0.1 USDC.");

        emit FeeReceived(msg.sender, msg.value);

        // Tạo contract con
        address newBase;
        string memory typeStr;
        
        if (_type == 1) { newBase = address(new BasicBase(msg.sender)); typeStr = "BASIC"; } 
        else if (_type == 2) { newBase = address(new VaultBase(msg.sender)); typeStr = "VAULT"; } 
        else if (_type == 3) { newBase = address(new NoteBase(msg.sender)); typeStr = "NOTE"; } 
        else { revert("Invalid Type"); }
        
        users[msg.sender].deployedBases.push(newBase);
        emit UserDeployed(msg.sender, newBase, typeStr);
        
        // Hoàn tiền thừa (nếu user lỡ gửi quá 0.1)
        if (msg.value > serviceFee) {
            payable(msg.sender).transfer(msg.value - serviceFee);
        }
    }

    // Hàm rút USDC phí thu được về ví chủ
    function withdrawNative() public {
        payable(msg.sender).transfer(address(this).balance);
    }

    // Hàm nhận tiền (để nạp quỹ nếu cần)
    receive() external payable {}
    
    // Helper xem thông tin
    function getUserStatus(address _user) public view returns (uint256, uint256, uint256, address[] memory) {
        return (users[_user].lastGMTime, users[_user].totalGM, users[_user].currentStreak, users[_user].deployedBases);
    }
}