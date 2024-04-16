// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

//一個很複雜但其實正常不會這麼使用的修飾子
/*執行的順序:
int a = 90
呼叫setA()後:
    int c = b;
        int c = a;
            a = 70;
            return;
                int c = a;
a = 50;
    c = a;
    a = 80;
故最終a = 80
*/
contract ModifierDemo {
    address owner;		//位址型別的變數
    int a = 90;
    
    modifier modifier1( int b) {
        int c = b;
        _; //這邊因為_;，故會先執行  modifier2 modifier3 modifier4 setA，最後才會回來繼續run
        c = a;
        a = 80;
    }
    
    modifier modifier2 {
        int c = a;
        _; //往下跳到執行modifier3
    }
    
    modifier modifier3 {
        a = 70;
        return; //因return 直接返回函數，往下跳到執行modifier4後不會再返回，故不執行 _;  a = 60;
        _;
        a = 60;
    }
    
    modifier modifier4 {
        int c = a;
        _;//往下跳到執行 setA()
    }
    
    //建構子，設置owner
    constructor() { 	
        owner = msg.sender;	
    }
    //modifier1(a)->這邊a先被傳入的是90
    function setA() public modifier1(a) modifier2 modifier3 modifier4{
        a = 50; 
    }
    
    function getA() public view returns(int){
        return a;
    }
}

