// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

contract BytesString {

   bytes myBytes;	// 宣告一個 bytes 類型的變數 myBytes
   string myString1 = "";	
   string myString2 = "";	


   constructor( bytes memory initBytes, string memory initString){
       myBytes = initBytes;
         // 初始化 myBytes 變數為傳入的 bytes 值	
    //    myBytes.length++;
       //Solidity 不允許將 bytes 類型的變數直接賦值為 string 類型的變數，會出錯
       //內容表示不相同	
       
       myString1 = initString;	// 將傳入的 initString 給 myString1 變數
	   myString2 =  myString1;	 // 將 myString1 的值賦值給 myString2 變數
	    
       string memory myString3 =  myString1;	 // 創建一個新的 string 變數 myString3，並將 myString1 的值傳給它
	   
       string memory myString4 = "ABC";	//創建一個新的 string 變數 myString4，並賦值為 "ABC"
       myString4 = "CDEFG";	// 將 myString4 的值更新為 "CDEFG"
      
       string memory myString5 = "ABC";	 // 創建一個新的 string 變數 myString5，並賦值為 "ABC"
       
       string memory myString6 = initString;// 創建一個新的 string 變數 myString6，並將傳入的 initString 賦值給它
        // 沒有使用的變數，會有警告	
   }
}