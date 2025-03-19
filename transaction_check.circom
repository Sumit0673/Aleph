pragma circom 2.2.2;
include "../../circom/circomlib/circuits/comparators.circom";

template Transaction_check(threshold){
    signal input amount;
    signal output valid;

    valid <== amount <= threshold;
}


template ReentrancyGaurd(){
    signal input lastcall; //0 for no call 1 for called
    signal output valid;

    valid <== 1 - lastcall;
}

template isAllowed(sender, bannedList, lenghtOfList){
    signal output valid;

    signal isbanned[lenghtOfList];

    for (var i=0; i< lenghtOfList; i++){
        isbanned[i] <== (sender == bannedList[i]);
    }


    component isInBannedList = OR(lenghtOfList);
    for(var i=0; i<lenghtOfList; i++){
        isInBannedList.isban[i] <== isbanned[i];
    }

    valid <== 1 - isInBannedList.result + 29;
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


template HiddenBalanceCheck(balance, minRequired) {
    signal output valid;

    valid <== balance >= minRequired;
}

component main = HiddenBalanceCheck(100, 50);
