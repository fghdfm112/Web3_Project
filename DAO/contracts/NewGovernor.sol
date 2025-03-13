// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "./ERC721Vending.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract DAOContract is IERC721Receiver{
    struct Voter {
        bool voted;
        uint vote;
    }

    struct Proposal {
        string description;
        uint voteCount;
        bool executed;
        uint voteEndTime;
        bool nftMinted; // Track NFT minting status
    }

    uint public membershipFee = 0.005 ether;
    mapping(address => bool) public members;

    Proposal[] public proposals;

    mapping(address => mapping(uint => Voter)) public voters; // Track votes for each proposal
    address public chairperson;
    ERC721Vending public nftContract;

    uint public winningProposalId;

    event ProposalCreated(uint proposalId, string description);
    event Voted(address voter, uint proposalId);
    event NFTMinted(uint tokenId, address recipient);
    event MembershipGranted(address indexed member);

    modifier onlyChairperson() {
        require(msg.sender == chairperson, "Only chairperson can call this");
        _;
    }

    function withdrawFunds() public {
        require(msg.sender == chairperson, "Only owner can withdraw");
        payable(chairperson).transfer(address(this).balance);
    }

    constructor(address _nftContractAddress) {
        chairperson = msg.sender;
        nftContract = ERC721Vending(_nftContractAddress);
    }

    // Create a new proposal for an NFT minting vote
    function createProposal(string memory description, uint _voteDuration) public onlyChairperson {
        proposals.push(Proposal({
            description: description,
            voteCount: 0,
            executed: false,
            voteEndTime: block.timestamp + _voteDuration,
            nftMinted: false
        }));
        emit ProposalCreated(proposals.length - 1, description);
    }

    // Users vote on a specific proposal
    function vote(uint proposalId) public {
        require(members[msg.sender], "Only DAO members can vote");
        require(proposalId < proposals.length, "Invalid proposal ID");
        require(block.timestamp < proposals[proposalId].voteEndTime, "Voting has ended for this proposal");
        require(!voters[msg.sender][proposalId].voted, "Already voted on this proposal");

        voters[msg.sender][proposalId].voted = true;
        voters[msg.sender][proposalId].vote = proposalId;
        proposals[proposalId].voteCount++;

        emit Voted(msg.sender, proposalId);
    }

    // End voting for a specific proposal
    // End voting and pick the proposal with the most votes after all proposals' end time has passed
    function endVoting() public onlyChairperson returns (uint) {
        require(proposals.length > 0, "No proposals available");

        // Check if all proposals have reached their voting end time
        for (uint i = 0; i < proposals.length; i++) {
            require(block.timestamp >= proposals[i].voteEndTime, "Voting is still ongoing for some proposals");
        }

        uint maxVotes = 0;
        bool foundWinner = false;

        // Find the proposal with the highest vote count
        for (uint i = 0; i < proposals.length; i++) {
            if (!proposals[i].executed && proposals[i].voteCount > maxVotes) {
                maxVotes = proposals[i].voteCount;
                winningProposalId = i;
                foundWinner = true;
            }
        }
        require(foundWinner, "No valid proposals to execute");

        proposals[winningProposalId].executed = true;

        return winningProposalId;
    }


    function mintWinningNFT() public onlyChairperson {

        require(proposals[winningProposalId].executed, "Voting must be finalized first");
        require(!proposals[winningProposalId].nftMinted, "NFT already minted for this proposal");
        require(address(this).balance >= winningProposalId * 0.001 ether, "DAO contract has insufficient funds");

        // Send ETH from the DAO contract to the NFT contract for minting
        nftContract.mint{value: winningProposalId * 0.001 ether}(winningProposalId);

        proposals[winningProposalId].nftMinted = true;

        emit NFTMinted(nftContract.totalSupply(), address(this));

    }


    function JoinDao() public payable {
        require(msg.value == membershipFee, "Must send exactly 0.005 ETH");
        require(!members[msg.sender], "Already a member");

        members[msg.sender] = true;
        emit MembershipGranted(msg.sender);
    }

    // IERC721Receiver implementation:
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external pure returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }

}
