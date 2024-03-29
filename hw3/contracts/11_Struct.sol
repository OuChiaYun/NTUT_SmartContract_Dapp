// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

// 創建名為 Struct 的合約
//展示如何定義結構、使用建構子初始化結構變數
contract Struct {
    struct User{
        string name;
        uint8 age;
        string email;
        string phone;
    }
    
    User member;
    
//建構子，使用者的姓名、年齡、郵件和電話作為參數，初始化 member 變數
    constructor( string memory _name, uint8 _age, string memory _email, string memory _phone) { 	
        member = User( {name:_name, age:_age, email:_email, phone:_phone});
        //member.name = _name;
        //member.age = _age;
        //member.email = _email;
        //member.phone = _phone;
        //註解掉的是一種的寫法，現在使用的是另一種
    }
    
    // 函數 queryName：返回使用者的姓名
    function queryName() public view returns(string memory){
        return member.name;
    }
    
    // 函數 queryName：返回使用者的年紀
    function queryAge() public view returns(uint8){
        return member.age;
    }
    
    // 函數 queryName：返回使用者的mail
    function queryEmail() public view returns(string memory){
        return member.email;
    }
    
    // 函數 queryName：返回使用者的phone
    function queryPhone() public view returns(string memory){
        return member.phone;
    }
}