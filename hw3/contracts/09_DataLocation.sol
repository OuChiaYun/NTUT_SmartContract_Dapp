// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;//編譯控制指令

//展示 Solidity 中資料位置的概念

//類似於class
contract DataLocation{

	uint[] storageData;	//storageData儲存在storage
//unsigned int 縮寫

//手動輸入該參數的類型
	function test1(uint[] memory memoryArray) public pure{ //memoryArray儲存在memory
	}
//好像函式的參數名稱只是用來在函式內部引用該參數的名稱，而不會影響到外部調用該函式時的參數名稱
//所以就算輸入 uint256[] i不會錯，但型別uint256[]  是必要的

	//可以試著輸入uint256[] memoryArray
	//Solidity 需要知道這個 memoryArray 是什麼類型的數據
	//memory 是臨時變量

	function test2(uint[] memory memoryArray) public {

		storageData = memoryArray;	//將memory變數內容複製一份給storage變數

		//var varData = storageData;	//付予變數的參照值，varData會儲存在storage
		//varData.length = 2;	//varData與storageData是參照關係，改變varData的長度->改變storageData的長度

		delete storageData;	
		//清空storageData的內容，也就是清空varData的內容

		//varData = memoryArray;	//不能執行，造成在storage中建立一個暫時但未命名的陣列，但storage是靜態配置，所以會發生衝突

		//delete varData;	//不能執行

		test3(storageData);	//以傳值方式呼叫test3函數

		test4(storageData);	//在memory中建立一個暫時性的複製，呼叫test4函數
	}

	function test3(uint[] storage storageArray) internal pure{}
	// public 所有訪問全公開
	//顧test3無法主動輸入
	//internal 可以訪問父類的內容，和private不相同
	function test4(uint[] memory memoryArray) public pure{} //pure 表示不消耗gas 

}