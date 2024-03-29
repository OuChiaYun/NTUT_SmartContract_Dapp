// SPDX-License-Identifier: MIT

pragma solidity ^0.4.26; //要試著去更改版本號


//創建名為 Var 的合約
contract Var {
    function test1() public pure returns(int8 value){ 
        int8 number = 10;
        // 創建一個 int8 型別的變數 number，賦值 10
        // 使用 var 關鍵字宣告一個自動型別的變數 auto，其值為 number 的值
        var auto = number; //var將根據右邊的表達式自動推斷出變數的類型，在0.4.0 版本前可用
        return auto;
    }
    // 函數 test2：返回一個 uint 型別的值
    function test2() public pure returns(uint value){ 
        uint8 x = 10;
        var y = x;
        // 在此循環中，var 關鍵字用於宣告自動型別的變數 y，其初始值為 x 的值
        // 如果需要使用其他變數作為循環的計數器，應該考慮使用其他明確的變數類型
        for( y=0; y < 100; y++){
            //do something
        }
        return y;
    }
}

