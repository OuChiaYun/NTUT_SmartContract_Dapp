// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;


// 建立一個名為 Enum 的合約
contract Enum {
    
    // 定義一個列舉型別 Month，它包含十二個可能的值，分別代表一年中的月份
    //從 0 開始編號
    enum Month{JAN,FEB,MAR,APR,MAY,JUN,JUL,AUG,SEP,OCT,NOV,DEC}
    
    Month choice; // 創建 choice 狀態變數，存儲 Month 型別的值
    
    function setMonth( Month value) public{ 
        choice = value; //choice 變數的值為傳入的 Month 型別參數 value
    }//if value = 6,Month.JUN
    
    function getMonth() public view returns(Month){ 
        return choice; //回傳choice
    }
   
}