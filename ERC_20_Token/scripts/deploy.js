const { ethers } = require("hardhat");

async function main() {
    console.log("Deploying MyToken to Sepolia...");

    const Token = await ethers.getContractFactory("MyToken");
    const token = await Token.deploy();
    await token.deployed();

    console.log("✅ Token deployed to:", token.address);
}

main().catch((error) => {
    console.error(error);
    process.exit(1);
});
