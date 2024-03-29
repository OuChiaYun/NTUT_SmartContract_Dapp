// SPDX-License-Identifier: MIT
//注意，這邊和02不同
pragma solidity ^0.8.24;
//版本

library Math {
    function add(int a, int b) public pure returns (int c) { //函數
        return a + b;
    }
    
    function add(uint a, uint b) public pure returns (uint c) { //函數
        return a + b;
    }
}

