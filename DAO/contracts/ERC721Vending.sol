// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

/// @title NFT Mint Smart Contract

// import helpful lib from OpenZeppelin

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ERC721Vending is ERC721Enumerable, Ownable {
    
    // Token Totally Supply, price, 
    uint public constant max_supply = 20;
    uint public constant unit_price = 0.001 ether;
    uint256 private _tokenId = 1;

    constructor() ERC721("ArtworkNFT", "ArtNFT") Ownable(msg.sender) {}

    function mint(uint amount) public payable {

        //Requirement check for minting the NFT
        require(amount > 0, "Must mint at least 1 NFT");
        require(msg.value >= amount * unit_price, "Insufficient ETH amount sent");
        require(totalSupply() + amount <= max_supply, "All ArtWork Sold Out");

        for (uint i = 0; i < amount; i += 1) {
            _safeMint(msg.sender, _tokenId);
            _tokenId += 1;            
        }
    }

    // Withdraw Function
    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }



}