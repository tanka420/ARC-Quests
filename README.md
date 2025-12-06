# 🛡️ ArcQuest: Native Gas Protocol Demo

ArcQuest is a decentralized quest platform built on **Arc Network (Circle)**. It demonstrates the power of **Native USDC Gas Abstraction** and **EIP-6963 Multi-Wallet** connectivity.

![Project Status](https://img.shields.io/badge/Status-Live-00F0FF?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

## 🌐 Live Demo
👉 **Experience the App:** [https://arc-quests.vercel.app/](https://arc-quests.vercel.app/)  
*(Requires Arc Testnet & Testnet USDC)*

## ✨ Key Features (Technical Highlights)

### 1. Native USDC Payments ⛽
Unlike traditional EVM chains, ArcQuest leverages Arc's native gas feature.
- **Zero Approval:** Users pay `0.1 USDC` directly in the transaction `value` field.
- **Gas Optimization:** Eliminates the specific ERC-20 `approve()` step, saving gas and improving UX.

### 2. EIP-6963 Multi-Wallet Injection 🔌
Goodbye wallet conflicts! ArcQuest supports:
- **Metamask** (Standard)
- **OKX Wallet** (via `window.okxwallet`)
- **Browser Injected** (Generic)

### 3. Factory Pattern Architecture 🏭
The Smart Contract uses a Factory pattern to deploy isolated instances for users:
- `IdentityBase`: Simple ownership contract.
- `VaultBase`: Secure asset storage logic.
- `MemoBase`: On-chain immutable notes.

## 🛠️ Tech Stack
- **Frontend:** Vanilla JS, Ethers.js v6
- **Smart Contract:** Solidity 0.8.28, Hardhat
- **Hosting:** Vercel (CI/CD)
- **Design:** Neon Cyberpunk UI (Glassmorphism + Particle Network)

## 📜 Contract Addresses (Arc Testnet)
| Contract | Address |
|----------|---------|
| **ArcQuestV3_Native** | `[0xe1629f143abBcb21D0d22c45b856c0945a94Ce76]` |
| **TAN Token** | `0x570D2fA99996a59af5e29270e6059383216Fe37a` |

## 👨‍💻 Author
Built with ❤️ by **tanka**.
