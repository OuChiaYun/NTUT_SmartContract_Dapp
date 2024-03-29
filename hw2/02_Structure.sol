// SPDX-License-Identifier: MIT
/**
主檔註解
*/

/*
多行註解
*/
//單行註解
pragma solidity ^0.8.24; //編譯器版本宣告

import "./03_Math.sol"; //引用其他合約

contract Structure {  //合約宣告，合約內容在大括號{}內
    
    address owner; //狀態變數
    uint data;

    event logData(uint dataToLog); //event事件

    modifier onlyOwner(){ //function modifier函數修飾子
        require(msg.sender == owner, "not owner");
        _;
    }

    constructor(address initOwner, uint initData){ //建構式
        owner = initOwner;
        data = initData;
    }

    function getData() public view returns(uint returnData){ //函數
        return data;
    }

    function setData(uint newData) public onlyOwner{  //函數宣告
        emit logData(newData);
        data = newData;
    }

    function increaseData(uint value) public{ //函數宣告
        data = Math.add(data, value);
    }


}
