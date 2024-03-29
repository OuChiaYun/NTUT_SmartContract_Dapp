// SPDX-License-Identifier: MIT
//注意，這邊和02不同
pragma solidity ^0.8.24;
//版本

library Math {
    function add(int a, int b) public pure returns (int c) { //函數
        return a + b;
    }
    //被引入到02_02_Structure，可使用兩個函式，會根據函式輸入的型別，呼叫不同的函式
    function add(uint a, uint b) public pure returns (uint c) { //函數
        return a + b;
    }
}
