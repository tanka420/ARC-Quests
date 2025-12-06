// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// 1. Contract con (Base của User)
contract UserBase {
    address public owner;
    uint256 public createdAt;
    string public version = "v2.0"; 
    
    constructor(address _owner) {
        owner = _owner;
        createdAt = block.timestamp;
    }
}

// 2. Contract chính (Factory)
contract ArcQuestV2 {
    IERC20 public rewardToken;
    
    struct UserStats {
        uint256 lastGMTime;       // Thời gian GM cuối cùng
        uint256 deployCount;      // Số lần đã deploy trong chu kỳ
        uint256 lastDeployCycle;  // Thời gian bắt đầu chu kỳ deploy 24h
        address[] deployedBases;  // Danh sách các contract con đã tạo
    }
    
    mapping(address => UserStats) public users;
    
    event UserGMed(address indexed user, uint256 timestamp);
    event UserDeployed(address indexed user, address newContractAddress);

    constructor(address _tokenAddress) {
        rewardToken = IERC20(_tokenAddress);
    }

    // --- LOGIC NHIỆM VỤ 1: GM (Cooldown 24h) ---
    function gm() public {
        UserStats storage user = users[msg.sender];
        
        // Kiểm tra xem đã qua 24h chưa (86400 giây)
        require(block.timestamp >= user.lastGMTime + 1 days, "Cooldown active: Please wait 24h.");
        
        // Cập nhật thời gian
        user.lastGMTime = block.timestamp;
        
        // Thưởng 5 TAN
        if (rewardToken.balanceOf(address(this)) >= 5 * 10**18) {
            rewardToken.transfer(msg.sender, 5 * 10**18);
        }
        
        emit UserGMed(msg.sender, block.timestamp);
    }

    // --- LOGIC NHIỆM VỤ 2: DEPLOY (2 lần / 24h) ---
    function deployBase() public {
        UserStats storage user = users[msg.sender];

        // Nếu đã qua 24h kể từ lần bắt đầu chu kỳ trước -> Reset lại từ đầu
        if (block.timestamp >= user.lastDeployCycle + 1 days) {
            user.deployCount = 0;
            user.lastDeployCycle = block.timestamp; // Bắt đầu chu kỳ 24h mới
        }

        // Kiểm tra giới hạn 2 lần
        require(user.deployCount < 2, "Limit reached: Max 2 deployments per 24h.");
        
        // Tạo contract con mới
        UserBase newBase = new UserBase(msg.sender);
        
        // Lưu trữ
        user.deployedBases.push(address(newBase));
        user.deployCount++;
        
        emit UserDeployed(msg.sender, address(newBase));
    }

    // Hàm lấy thông tin cho Frontend hiển thị
    function getUserStatus(address _user) public view returns (
        uint256 lastGM, 
        uint256 deployCount, 
        uint256 lastDeployCycle,
        address[] memory bases
    ) {
        return (
            users[_user].lastGMTime,
            users[_user].deployCount,
            users[_user].lastDeployCycle,
            users[_user].deployedBases
        );
    }
}