// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;	

contract HelloWorld {	
    
    //宣告
    
    address owner;		
    string greetStr="Hello World";	
    
    constructor() { 		
        owner = msg.sender;		
    }
    //建構子，owner = sender
    
    //view 僅讀取合約，不改變變量
    function greet() public view returns (string memory) { 	
        
        //如果呼叫者的地址與合約的擁有者地址相同
        if( msg.sender == owner) {					
            //回傳呼叫strContact函式結果		
            return strContact( greetStr, " ", "-Boss");	 //會輸出	 Hello World -Boss
        } else { 
            return strContact( greetStr, " ", "-Guest");
            //strContact 連接 "greetStr" " " "-Guest"
        }
    }
    
    // 串聯三個字串以形成新的字串
    function strContact( string memory _a, string memory _b, string memory _c) private pure returns ( string memory) {
        bytes memory _ba = bytes(_a);
        bytes memory _bb = bytes(_b);
        bytes memory _bc = bytes(_c);
        //memory 臨時變量
        
        string memory len = new string(_ba.length + _bb.length + _bc.length);
        //分配足夠的記憶體空間以容納 _ba、_bb 和 _bc 三個字串的長度之和。
        bytes memory abc = bytes(len);
        

        uint k = 0;
        uint i = 0;
        for(i = 0 ; i < _ba.length; i++) abc[k++] = _ba[i];
        for(i = 0 ; i < _bb.length; i++) abc[k++] = _bb[i];
        for(i = 0 ; i < _bc.length; i++) abc[k++] = _bc[i];
        //逐字複製
        return string(abc);
    }
}