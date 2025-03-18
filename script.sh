circom transaction_check.circom --r1cs --wasm --sym --c
cd transaction_check_js
node generate_witness.js transaction_check.wasm ../input.json witness.wtns
snarkjs wtns export json witness.wtns witness.json
cd ..