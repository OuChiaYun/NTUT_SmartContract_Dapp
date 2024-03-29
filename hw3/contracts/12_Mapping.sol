// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

// 創建名為 Mapping 的合約
//使用一個 mapping 變數 member，它將字串類型的 _id 映射到對應的使用者結構

contract Mapping {
    
    // 定義名為 User 的結構，包含用戶的姓名、年齡、郵箱和電話
    struct User{
        string name;
        uint8 age;
        string email;
        string phone;
    }
    
    mapping(string=>User) member; // mapping 型別可看做類似是一個 hash tables

    function createMember( string memory _id, string memory _name, uint8 _age, string memory _email, string memory _phone) public{
        member[_id] = User({ name:_name, age:_age, email:_email, phone:_phone});
    }//// 函數 createMember：創建新用戶，並加到 mapping 
    
    function queryMember( string memory _id) public view returns( string memory _name, uint8 _age, string memory _email, string memory _phone){
        return (member[_id].name, member[_id].age, member[_id].email, member[_id].phone); 
    }// 函數 queryMember：查詢指定 ID 用戶信息

}