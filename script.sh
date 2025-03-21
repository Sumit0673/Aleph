#!/bin/bash

# Step 4: Compile the Circom Circuit
circom transaction_check.circom --r1cs --wasm --sym --c

# Step 5: Generate Trusted Setup
snarkjs groth16 setup transaction_check.r1cs pot12_final.ptau circuit_0000.zkey
snarkjs zkey contribute circuit_0000.zkey circuit_final.zkey --name="First Contributor" -v
snarkjs zkey export verificationkey circuit_final.zkey verification_key.json

# Step 6: Generate Witness
node transaction_check_js/generate_witness.js transaction_check_js/transaction_check.wasm input.json witness.wtns

# Step 7: Generate Proof
snarkjs groth16 prove circuit_final.zkey witness.wtns proof.json public.json

# Step 8: Verify Proof
snarkjs groth16 verify verification_key.json public.json proof.json

# Step 9: Generate Solidity Verifier
snarkjs zkey export solidityverifier circuit_final.zkey verifier.sol

# Step 10: Deploy and Test Smart Contract
# (Assuming Hardhat or Foundry for deployment)
cp verifier.sol contracts/
npx hardhat compile
npx hardhat test

# Step 11: Deploy Smart Contract
npx hardhat run scripts/deploy.js --network goerli  # Change to your desired network

# Step 12: Interact with the Contract
npx hardhat console --network goerli <<EOF
const ZKFirewall = await ethers.getContractFactory("ZKFirewall");
const zkFirewall = await ZKFirewall.attach("<DEPLOYED_CONTRACT_ADDRESS>");
await zkFirewall.validateTransaction(publicInputs, proof);
EOF
