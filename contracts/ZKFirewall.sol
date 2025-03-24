// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./verifier.sol"; // Import the ZK Verifier contract

contract ZKFirewall is Groth16Verifier {  // ✅ Use the correct contract name
    function validateTransaction(
        uint256[2] calldata a,
        uint256[2][2] calldata b,
        uint256[2] calldata c,
        uint256[1] calldata input
    ) public view returns (bool) {
        return verifyProof(a, b, c, input);
    }
}
