// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import "hardhat/console.sol";

//這裡environment 要更改，不要用VM，用shanghai
//展示需要付費時，合約的運作、扣款付款等

contract Sample1 {

    uint256 public s1 = 0; //無號uint256

    constructor() payable{
        require( msg.value == 1 ether, "Need to pay 1 ETH");
        console.log("constructor");     //這邊是 1 ETH，要注意部屬時，depoly 會變紅，代表要花錢
    }
    //value 需要在部屬前先設定好，但如果之後有其他需要付費的地方，也要在部屬前的區塊進行value的設定

    fallback() external payable {
        console.log("fallback");        
    }
    //fallback 函數是一個在智能合約接收到以太幣但沒有匹配到任何其他函數時調用的特殊函數。在這段代碼中
    
    receive() external payable{
        console.log("receive");      
    }
    //receive 函數是一個在智能合約接收到以太幣時調用的特殊函數
	
    function set(uint256 value) public payable{
        require( msg.value == 0.01 ether, "Need to pay 0.01 ETH");
        s1 = value; //msg.value 需在depoly 的位置設定好付的金額
        //value != msg.value ，msg.value 是付的錢，value是你設定的值
    }
        
    function getContractBalance() public view returns( uint256){
        return address(this).balance; //合約金額
    }

    function getEOAAddress() public view returns( uint256){
        return msg.sender.balance; //所在帳戶剩餘金額
    }

    function destructor(address recipt) external{
        selfdestruct(payable(recipt)); //recipt 負責接收錢，被destructor的付錢
    }
 
}