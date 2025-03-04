# 🚀 ERC-20 Token Project

This project demonstrates how to create, deploy, and interact with an ERC-20 token.

## 📌 Features
- Custom ERC-20 token (`ET`)
✅ Deploys on **Sepolia testnet**  
- Deployment using **Hardhat**
- Fully open-source with **MIT License**

## 📂 Project Structure
ERC20_20-Token/ │── contracts/ │ ├── ERC20Token.sol │── scripts/ │ ├── deploy.js │── README.md │── .gitignore │── LICENSE


## 🛠️ Technologies Used
- **Solidity** – Smart contract language
- **Hardhat** – Ethereum development framework
- **OpenZeppelin** – Secure contract libraries
- **GitHub Desktop** – Version control

## 🚀 Deployment Guide
### 1️⃣ Install Dependencies

```sh
npm install hardhat @openzeppelin/contracts ethers dotenv
```
### 2️⃣ Configure Hardhat for Sepolia

- **INFURA_SEPOLIA_RPC_URL** -
- **process.env.PRIVATE_KEY** -

### 3️⃣ Create a .env File

```env
INFURA_SEPOLIA_RPC_URL="YOUR_INFURA_PROJECT_URL"
PRIVATE_KEY="YOUR_METAMASK_PRIVATE_KEY"
```

### 4️⃣ Deploy Using Hardhat
```sh
npx hardhat run scripts/deploy.js --network sepolia
```

### 5️⃣ Verify on Sepolia Etherscan

## 🏆 What I Learned
✅ Writing Solidity smart contracts
✅ Using OpenZeppelin’s ERC-20 library
✅ Deploying contracts using Hardhat on Sepolia

## 📜 License
This project is licensed under the MIT License.