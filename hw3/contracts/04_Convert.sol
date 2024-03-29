// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

contract Convert {

   function test1() public pure {
       uint8 len8 = 10;
       uint128 len128 = len8;
       //不出錯，因為len8 = 10 是正數
   }
   
   function test2() public pure returns( uint128) {
    //會發生形別轉換錯誤
       int8 len8 = -10;
       uint128 len128 = len8;	
    //    uint128 len128 = uint128(len8);	
    // 如果要將 int8 型別轉換為 uint128 型別，必須先將其轉換為正數，然後再賦值
   }
}