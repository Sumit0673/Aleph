// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./verifier.sol"; // Import the ZK Verifier contract

contract ZKFirewall is Verifier {
    function validateTransaction(
        uint256[2] memory a,
        uint256[2][2] memory b,
        uint256[2] memory c,
        uint256[1] memory input
    ) public view returns (bool) {
        return verifyProof(a, b, c, input);
    }
}
