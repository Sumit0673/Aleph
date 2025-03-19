const fs = require("fs");
const { execSync } = require("child_process");

function generateProof() {
    try {
        console.log("🚀 Generating witness...");
        execSync("snarkjs wtns calculate ./transaction_check_js/transaction_check.wasm input.json witness.wtns");

        console.log("🔐 Generating proof...");
        execSync("snarkjs groth16 prove transaction_check.zkey witness.wtns proof.json public.json");

        console.log("📌 Formatting proof for Solidity...");

        // Get raw output from snarkjs generatecall
        let proofData = execSync("snarkjs generatecall").toString().trim();

        if (!proofData) {
            throw new Error("❌ Proof data is empty! Check if proof.json was generated correctly.");
        }

        console.log("📝 Raw Proof Data:", proofData);  // Debugging step

        // Ensure valid JSON structure by wrapping it inside an array
        proofData = `[${proofData}]`;

        // Try parsing JSON safely
        let parsedProof;
        try {
            parsedProof = JSON.parse(proofData);
        } catch (err) {
            throw new Error("❌ Invalid JSON format from snarkjs generatecall. Ensure proof structure is correct.");
        }

        // Ensure proof structure
        if (!Array.isArray(parsedProof) || parsedProof.length !== 4) {
            throw new Error("❌ Unexpected proof format. Expected an array with 4 elements.");
        }

        // Structure into an object
        const formattedProof = {
            a: parsedProof[0],
            b: parsedProof[1],
            c: parsedProof[2],
            input: parsedProof[3]
        };

        // Save formatted proof
        fs.writeFileSync("formattedProof.json", JSON.stringify(formattedProof, null, 2));
        console.log("✅ Proof saved in formattedProof.json!");

    } catch (error) {
        console.error("❌ Error:", error.message);
    }
}

generateProof();
