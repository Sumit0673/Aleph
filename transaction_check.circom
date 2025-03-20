pragma circom 2.2.2;


template threshold_check(){
    signal input threshold;
    signal input amount;
    signal output valid;

    valid <-- (amount <= threshold);
}


template ReentrancyGaurd(){
    signal input lastcall;
    signal output valid;

    valid <== 1 - lastcall;
}

template isAllowed(lenghtOfList){
    signal input sender;
    signal input bannedList[lenghtOfList];
    signal output valid;

    signal isbanned[lenghtOfList];

    for (var i=0; i< lenghtOfList; i++){
        isbanned[i] <-- (sender == bannedList[i]);
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
template AND(n){
    signal input isban[n];
    signal output result;
    var midval = 1;

    for(var i=0; i < n; i++){
        
        midval = midval && isban[i];
    }
    result <-- midval;
}


template TimestampValidation() {
    signal input currentTime;
    signal input txTimestamp;
    signal input maxDelay;  
    signal output valid;
    valid <-- (currentTime - txTimestamp) <= maxDelay;
}

template OverflowCheck() {
    signal input balance;
    signal input amount;
    signal input maxUint;
    signal output valid;
    valid <-- (balance + amount) <= maxUint;
}

template MultiSig() {
    signal input approvals;
    signal input requiredSignatures;
    signal output valid;
    valid <-- (approvals >= requiredSignatures);
}


template HiddenBalanceCheck() {
    signal input balance;
    signal input minRequired;
    signal output valid;

    valid <-- (balance >= minRequired);
}


template merger(lenghtOfList){
    signal input threshold;
    signal input amount;
    signal input lastcall;
    signal input sender;
    // signal input lenghtOfList;
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

    component Thresh_check = threshold_check();
    Thresh_check.amount <== amount;
    Thresh_check.threshold <== threshold;

    component reentrance = ReentrancyGaurd();
    reentrance.lastcall <== lastcall;

    component allowance = isAllowed(lenghtOfList);
    allowance.sender <== sender;

    for (var i=0; i< lenghtOfList; i++){
        allowance.bannedList[i] <== bannedList[i];
    }

    component time_check = TimestampValidation();
    time_check.currentTime <== currentTime;
    time_check.txTimestamp <== txTimestamp;
    time_check.maxDelay <== maxDelay;

    component overflow = OverflowCheck();
    overflow.balance <== balance;
    overflow.amount <== amount;
    overflow.maxUint <== maxUint;

    component sig_valid = MultiSig();
    sig_valid.approvals <== approvals;
    sig_valid.requiredSignatures <== requiredSignatures;

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

    component final_checks = AND(7);
    for(var i=0; i<7; i++){
        final_checks.isban[i] <== isvalid[i];
    }



    isValidTransaction <-- final_checks.result;

}

component main = merger(5);


