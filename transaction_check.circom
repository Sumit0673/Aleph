pragma circom 2.2.2;

include "../../circom/circomlib/circuits/comparators.circom";

template threshold_check(threshold, amount){
    signal output valid;

    valid <== amount <= threshold;
}


template ReentrancyGaurd(lastcall){
    signal output valid;

    valid <== 1 - lastcall;
}

template isAllowed(sender, lenghtOfList){
    signal input bannedList[lenghtOfList];
    signal output valid;

    signal isbanned[lenghtOfList];

    for (var i=0; i< lenghtOfList; i++){
        isbanned[i] <== (sender == bannedList[i]);
    }


    component isInBannedList = OR(lenghtOfList);
    for(var i=0; i<lenghtOfList; i++){
        isInBannedList.isban[i] <== isbanned[i];
    }

    valid <== 1 - isInBannedList.result;
}

template OR(n){
    signal input isban[n];
    signal output result;
    var midval = 0;

    for(var i=0; i < n; i++){
        
        midval = midval | isban[i];
    }
    result <-- midval;
}


template TimestampValidation(currentTime, txTimestamp, maxDelay) {
    signal output valid;
    valid <== (currentTime - txTimestamp) <= maxDelay;
}

template OverflowCheck(balance, amount, maxUint) {
    signal output valid;
    valid <== (balance + amount) <= maxUint;
}

template MultiSig(approvals, requiredSignatures) {
    signal output valid;
    valid <== approvals >= requiredSignatures;
}


template HiddenBalanceCheck() {
    signal input balance;
    signal input minRequired;
    signal output valid;

    valid <== (balance >= minRequired);
}


template merger(){
    signal input threshold;
    signal input amount;
    signal input lastcall;
    signal input sender;
    signal input lenghtOfList;
    signal input bannedList[lenghtOfList];
    signal input currentTime;
    signal input txTimestamp;
    signal input maxDelay;
    signal input balance;
    signal input maxUint;
    signal input approvals;
    signal input requiredSignatures;
    signal input minRequired;

    signal output isValidTransaction;

    signal isvalid[7];

    component Thresh_check = threshold_check(amount, threshold);
    component reentrance = ReentrancyGaurd(lastcall);
    component allowance = isAllowed(sender, lenghtOfList);
    for (var i=0; i< lenghtOfList; i++){
        allowance.bannedList[i] <== bannedList[i];
    }
    component time_check = TimestampValidation(currentTime, txTimestamp, maxDelay);
    component overflow = OverflowCheck(balance, amount, maxUint);
    component sig_valid = MultiSig(approvals, requiredSignatures);
    component hid_balance = HiddenBalanceCheck();
    hid_balance.balance <== balance;
    hid_balance.minRequired <== minRequired;


    isvalid[0] <== Thresh_check.valid;
    isvalid[1] <== reentrance.valid;
    isvalid[2] <== allowance.valid;
    isvalid[3] <== time_check.valid;
    isvalid[4] <== overflow.valid;
    isvalid[5] <== sig_valid.valid;
    isvalid[6] <== hid_balance.valid;

    component final_checks = OR(7);
    for(var i=0; i<7; i++){
        final_checks.isban[i] <== isvalid[i];
    }

    isValidTransaction <-- final_checks.result;

}

component main = merger();


