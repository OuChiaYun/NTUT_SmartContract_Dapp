// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

contract student_con{
    address private owner;

    struct student{
    address account; // 帳號（位址）
    string phone;// 電話
    string email;// Email
     //    string id;// 學號 id 不需要另外存，因為會用map 的 key 存取
    }

    mapping(string=>student) student_map; // map key 是 string
    string[] student_arr; //儲存ID

    modifier onlyOwner(){
        require( owner == msg.sender, "Only Owner"); //檢查是否為管理者
        _;
    }

    //查詢合約管理者帳號
    function getOwner() public view returns(address account) {
        return owner;
    }

    //設定合約管理者帳號
    function setOwner(address newOwner) public onlyOwner {
        owner = newOwner;
    }


    //建構式
    constructor() {
        owner = msg.sender; //設定合約管理者
    }	

//功能

    //新增一筆學生資料(onlyOwner)
    function add_student(address _account,string memory _id,string memory _phone,string memory _email) public onlyOwner{
        require(_account == address(_account),"Invalid address"); //傳入帳戶不為0
        require(student_map[_id].account == address(0), "Student ID already exists");  //對應帳戶非0時觸發


        ( bool find, uint256 index) = get_index_by_account(_account); //檢查帳戶是否存在

        if( (find==false) && index>=0){
            student_map[_id] = student({ account:_account, phone: _phone, email : _email });
            student_arr.push(_id); //新增資料到map、arr
        }else{
            revert("Student address exist");
        }

    }


    //查詢:根據帳號查詢學生資料索引
    function get_index_by_account(address  _account) public view returns(bool find,uint256 index){
       
        require(_account == address(_account),"Invalid address");

        for(uint256 i = 0; i< student_arr.length; i++) {
            if(student_map[student_arr[i]].account == _account){
                return (true, i); //找到回傳true
            }
        }
        return (false, 0); //沒找到回傳false
    }


    //查詢:根據學號查詢學生資料索引
    function get_index_by_id(string memory _id) public view returns(bool find,uint256 index){

        for(uint256 i = 0; i< student_arr.length; i++) {
            if(cmp_str(student_arr[i],_id) == true)
                return (true, i);//找到回傳true
        }
        return (false, 0);//沒找到回傳false
    }

    //查詢:根據索引查詢學生資料
    function search_data_by_index(uint256 _index) public view returns(address _account,string memory return_id, string memory _phone, string memory _email){
        
        if( _index >= student_arr.length || _index < 0){
            revert("Index error");
        } //確認index是否合法

        string memory _id = student_arr[_index]; //查找資料
        return (student_map[_id].account,_id, student_map[_id].phone, student_map[_id].email);
        
    }

    //查詢:根據學號查詢學生資料
    function search_data_by_id(string memory _id) public view returns(address _account,string memory return_id, string memory _phone, string memory _email){
        require(student_map[_id].account != address(0), "Student not exist");  //對應帳戶0時觸發，表此id不存在，故address為0

        return (student_map[_id].account,_id, student_map[_id].phone, student_map[_id].email);
    } // public view returns表明它不會修改合約的狀態，只是返回數據


    //修改：根據學號修改帳號、電話、Email(onlyOwner)

    function change_by_ID(address _account,string memory _id,string memory _phone,string memory _email) public onlyOwner{
        
        require(_account == address(_account),"Invalid address"); //判斷地址是否合規

        ( bool find, uint256 index) = get_index_by_id(_id);

        if( find == false && index==0){
            revert("ID not found"); //ID不存在
        }

        ( bool a_find, uint256 a_index) = get_index_by_account(_account);

        if( a_find && index!= a_index){
            revert("address exist"); //address存在
        }


        student_map[_id] = student({ account:_account, phone: _phone, email : _email }); //更改內容
    }

    //刪除：根據學號刪除學生資料(onlyOwner)
    function delete_data_by_id(string memory _id) public onlyOwner {

        (bool find, uint256 index) = get_index_by_id(_id); // 取得學號

        if (find && index >= 0) {
            delete student_map[_id];
            student_arr[index] = student_arr[student_arr.length - 1];
            student_arr.pop(); //將id從array 刪除
        } else {
            revert("Student not exist");
        }
    }

        //字串比對
    function cmp_str(string memory a, string memory b) private pure returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
    }

}