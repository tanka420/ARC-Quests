// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TAN is ERC20 {
    constructor(uint256 initialSupply) ERC20("TAN Token", "TAN") {
        _mint(msg.sender, initialSupply); // Phát hành token cho địa chỉ deployer
    }
}
