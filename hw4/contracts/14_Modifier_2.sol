// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
//編譯器可以使用 Solidity 0.7.0 到 0.8.9 版本中的任何一個版本來編譯這個合約
//展示修飾子
/**
 * @title Owner
 * @dev Set & change owner
 */
contract Owner {

    address private owner;
    
    // event for EVM logging
    event OwnerSet(address indexed oldOwner, address indexed newOwner); //宣告一個事件，記錄擁有者更改
    //藉由觸發event寫入log，再觸發監聽器執行對應動作
    //indexed屬性，到時候觸發時這個變數對應寫入的值就會寫在topics裡

    // modifier to check if caller is owner
    modifier isOwner() {
        // If the first argument of 'require' evaluates to 'false', execution terminates and all
        // changes to the state and to Ether balances are reverted.
        // This used to consume all gas in old EVM versions, but not anymore.
        // It is often a good idea to use 'require' to check if functions are called correctly.
        // As a second argument, you can also provide an explanation about what went wrong.
        require(msg.sender == owner, "Caller is not owner");
        _; //_:表後面接續原本的程式碼片段，故在isOwner函式中會先確認Caller的權限
    }
    
    /**
     * @dev Set contract deployer as owner
     */
     //建構子
    constructor() {
        owner = msg.sender; // 'msg.sender' is sender of current call, contract deployer for a constructor
        emit OwnerSet(address(0), owner); //透過emit 這樣就可以觸發 event=> OwnerSet
    }//觸發事件，記錄合約的初始擁有者
    //address(0) 在 Solidity 中表示零地址或空地址，也就是地址值為 0 的特殊地址

    /**
     * @dev Change owner
     * @param newOwner address of new owner
     */
    
    function changeOwner(address newOwner) public isOwner {
        emit OwnerSet(owner, newOwner);
        owner = newOwner; //將舊的owner改新的
    }

    /**
     * @dev Return owner address 
     * @return address of owner
     */
    function getOwner() external view returns (address) {
        return owner; //展現現在的owner是哪個
    }
}