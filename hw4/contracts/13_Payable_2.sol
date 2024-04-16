// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import "hardhat/console.sol";
//創建兩個智能合約Sample1和Sample2
//一個檔案可以多個合約
//要部屬兩個合約，記得要在面板上更改contracts

contract Sample1 {
    int a; //最開始的a
    
    constructor() payable{
    }
    
    function set(int value) public payable{
        a = value;//設定a
    }
    
    function get() public view returns( int){
        return a; //回傳a
    }
}

contract Sample2 {
    Sample1 s1;
//通過 new 關鍵字創建了一個 Sample1 的新實例並將 10 個以太發送給它
    constructor() payable{
        s1 = (new Sample1){value: 10}(); 
        //會向 Sample1 合約轉移10個以太 
        //s1 = () 
        //故一開始就必須先在value設定為10來支付
    }
    
    fallback() external payable {
        console.log("fallback");        
    }//當以太幣被轉發到合約地址時，如果沒有明確指定函數，或者調用的函數不存在，就會觸發 
    
    receive() external payable{
        console.log("receive");      
    }//當以太幣被轉發到合約地址時，如果沒有匹配到明確指定的函數，會觸發
	
    function set(int value) public {
        s1.set{value:10}(value);    //0.6.2
    } //向 Sample1 合約轉移10個以太
    //但是會花錢
    //value: 10表示向Sample1合約轉移了10個以太
    //在外面部屬的sample1，跟smaple2部屬出來的s1不適同個東西，故兩者a不同，值不互通
    function get()  public view returns( int){
        return s1.get();
    }//取得s1的值
    
    function getBalance() public view returns( uint256){
        return address(this).balance;
    }//合約的餘額

    function getS1Address() public view returns( address){
        return address(s1);
    }//透過此函數可以看到s1合約部屬帳號的實際位址
}