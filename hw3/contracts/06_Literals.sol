// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

contract Literals {
    //數字常量，支持任意精度，直到被轉換成不是常量的型式
    function test1() public pure returns(uint8 v){			
       uint8 x = (2**10 + 1) - (2**10);	//雖然在運算的過程中超過uint8的範圍，但結果沒有超過，不會發生溢位
       return x;
    }
   
    function test2() public pure returns(uint8 v){			
       v = .5 * 2;	//非整數的數值，運算完為整數，還是能得到結果1
       // 上述操作實際上是將浮點數 0.5 轉換為整數,.5表0.5
       //v = .5 * 3;	//非整數的數值，但運算完為非整數，編譯時產生錯誤
    }
    
    function test3() public pure returns(uint v){		
        uint a  = 5;
        uint x = a/2 + a/2; //運算結果會被截斷
        //uint x = 5/2 + 5/2;	//運算結果不會被截斷
        return x;
    }
    
	//數字常量，用於表達加密貨幣
    function test4() public pure returns(bool){
        //return ( 2 ether == 2000 finney);   //0.7.0版開始不適用
        return ( 2 ether == 2000000000000000000 wei); 
        //return ( 2 ether == 2e18 wei); 
    }

	//數字常量，用於表達日期時間    
    function test5() public pure returns(bool){
        return ( 1 hours == 61 minutes);
    }
    
	//字串常量
    function test6() public pure returns(string memory){
        return modify("Hellx World");
    }
    
    function modify(string memory s) public pure returns(string memory){
        bytes(s)[4] = "o";
        return string(s);  //會將字串s中的字元[4]改為o，並回傳s
    }
    
	//十六進制常量
    function test7() public pure returns(string memory){
        return hex"48454c4c4f";
    }
    
	//位址常量
    function test8() public pure returns(address v){		
        return 0xD7D3C0F50E6cF82F0dd237f803C3278cBcD68f53;
    }
}