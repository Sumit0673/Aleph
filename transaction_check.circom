include "../../circom/circomlib/circuits/comparators.circom";

template Transaction_check(threshold){
    signal input amount;
    signal output valid;

    component check_less = LessEqThan(11);
    check_less.in[0] <== amount;
    check_less.in[1] <== threshold;

    valid <== check_less.out;
}


template ReentrancyGaurd(){
    signal input lastcall; //0 for no call 1 for called
    signal output iscalled;

    iscalled <== 1 - lastcall;
}

template 