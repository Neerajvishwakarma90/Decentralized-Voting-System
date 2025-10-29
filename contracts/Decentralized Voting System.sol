// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DecentralizedVotingSystem {
    struct Candidate {
        string name;
        uint voteCount;
    }

    address public owner;
    bool public votingActive;

    mapping(address => bool) public hasVoted;
    Candidate[] public candidates;

    constructor(string[] memory _candidateNames) {
        owner = msg.sender;
        for (uint i = 0; i < _candidateNames.length; i++) {
            candidates.push(Candidate({ name: _candidateNames[i], voteCount: 0 }));
        }
        votingActive = true;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    modifier isVotingActive() {
        require(votingActive, "Voting is not active");
        _;
    }

    // Core Function 1: Vote for a candidate
    function vote(uint candidateIndex) public isVotingActive {
        require(!hasVoted[msg.sender], "You have already voted");
        require(candidateIndex < candidates.length, "Invalid candidate index");

        hasVoted[msg.sender] = true;
        candidates[candidateIndex].voteCount += 1;
    }

    // Core Function 2: End the voting process
    function endVoting() public onlyOwner {
        votingActive = false;
    }

    // Core Function 3: Get winner details
    function getWinner() public view returns (string memory winnerName, uint winnerVotes) {
        require(!votingActive, "Voting still active");
        uint highestVotes = 0;
        uint winnerIndex = 0;

        for (uint i = 0; i < candidates.length; i++) {
            if (candidates[i].voteCount > highestVotes) {
                highestVotes = candidates[i].voteCount;
                winnerIndex = i;
            }
        }

        winnerName = candidates[winnerIndex].name;
        winnerVotes = candidates[winnerIndex].voteCount;
    }
}
