// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;


// 創建名為 Array 的合約
contract Array {
   
   int[] myArray1;  //宣告狀態變數myArray1是動態長度的有號整數陣列，儲存在storage中
   
   constructor(){
       
   }
   
   function setValue( uint index, int value) public {
        
        // 檢查索引是否在 myArray1 的範圍內 //
        require(index < myArray1.length, "index error");
        //require確認條件有效性

        myArray1[index] = value;	//設定myArray1陣列索引index內的值為value
    
        int[] memory myArray2 = myArray1;	//myArray2指向myArray同一個參考位址
        
        // uint24[3] memory myArray3 = [1,2,3];	//宣告區域變數myArray3是固定長度的無號整數陣列，儲存在memory中，
        //並以指定陣列常量為初值，因為不能隱式轉換，因此編譯時會產生錯誤
        uint24[3] memory myArray3 = [uint24(1),2,3];  //同上，透過第一個元素宣告陣列的元素型別，可正確編譯
        // 創建一個記憶體中的 uint24 固定長度整數陣列 myArray3，並初始化為 [1, 2, 3]
        
        // uint8[2] myArray5 = [1,2];  //宣告區域變數myArray5是固定長度的無號整數陣列，儲存在storage中，不能將陣列常量指定給複雜型別
        uint8[2] memory myArray5; 
        myArray5[0] = 1;
        myArray5[1] = 2;
        // myArray2 ;
        // myArray3; //因為有未使用的變量，所以前面的myArray2、myArray3會warning
        //myArray5[2] = 3;	//不能設定超出陣列長度的值
        
   }
   
   function getValue( uint index ) public view returns( int value){
        require(index < myArray1.length, "index error");
         // 如果索引超出了 myArray1 的範圍，將拋出異常
        value = myArray1[index];
        // 設定 myArray1 陣列索引 index 內的值為 value
   }
   
    function getLength() public view returns( uint256){
        return myArray1.length;
    }
    
    function addValue( int value) public {
        myArray1.push(value); //value放入數組
    }
}