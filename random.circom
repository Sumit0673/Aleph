pragma circom 2.2.2;

template check(){
    signal input a; 
    signal input b;
    signal val[10];
    signal output valid;
    
    valid <-- a < b;

}
component main = check();