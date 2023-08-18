// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SDIStablecoin {
    address public owner;

    mapping(bytes32 => bool) public verifiedActivities;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    function submitActivityWithVerification(bytes32 _hashedData, string memory _verificationProof) public {
        // Perform ML verification and get verification result (true/false)
        bool mlVerificationResult = performMLVerification(_verificationProof);

        // Fetch data from Chainlink oracle
        uint256 chainlinkData = fetchChainlinkData();

        // Compare user-submitted hash with Chainlink data hash
        bytes32 chainlinkDataHash = keccak256(abi.encodePacked(chainlinkData));
        require(chainlinkDataHash == _hashedData, "Invalid data submission");

        // Ensure ML verification succeeded and activity is not already verified
        require(mlVerificationResult && !verifiedActivities[_hashedData], "Invalid or duplicate submission");

        // Mark activity as verified and perform rewards
        verifiedActivities[_hashedData] = true;
        rewardUser(msg.sender);

        emit ActivitySubmitted(msg.sender, _hashedData);
    }

    // Placeholder functions for ML verification and Chainlink data fetching
    function performMLVerification(string memory _verificationProof) internal pure returns (bool) {
        // Implement your ML verification logic here
        return true; // For illustration purposes
    }

    function fetchChainlinkData() internal pure returns (uint256) {
        // Implement your Chainlink data fetching logic here
        return 100; // For illustration purposes
    }

    // Placeholder function for rewarding users
    function rewardUser(address _user) internal {
        // Implement reward logic and SDI coin minting here
    }

    // Events
    event ActivitySubmitted(address indexed user, bytes32 indexed hashedData);
}
