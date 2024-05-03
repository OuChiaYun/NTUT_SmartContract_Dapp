// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

interface IERC721 {
    //當任何NFT的所有權更改時觸發，包括創建和銷毀時，合約創建時除外
    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed tokenId
    );
    //當更改或確認NFT的授權位址時觸發
    //_approved為0表示沒有授權的位址
    //發生Transfer事件時，表示該NFT的授權位址重置為0
    event Approval(
        address indexed owner,
        address indexed approved,
        uint256 indexed tokenId
    );

    //所有者啟用或禁用操作員時觸發，操作員可管理所有者所持有的NFTs
    event ApprovalForAll(
        address indexed owner,
        address indexed operator,
        bool approved
    );

    //傳回_owner位址持有的NFTs數量
    function balanceOf(address owner) external view returns (uint256 balance);

    //根據_tokenId索引值傳回NFT持有者的位址
    function ownerOf(uint256 tokenId) external view returns (address owner);

    //從_from位址轉移NFT tokenId的所有權到_to位址，data為附加的參數，觸發Transfer事件
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) external;

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    // 從_from位址轉移NFT tokenId的所有權到_to位址，觸發Transfer事件
    // 執行者負責確認_to位址是否有能力接收NFTs，否則可能永久丟失
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    //更改或確認NFT的授權位址，_approved 為0表示沒有授權的位址，觸發Approval事件
    function approve(address to, uint256 tokenId) external;

    //啟用或禁用操作員管理，觸發ApprovalForAll事件
    function setApprovalForAll(address operator, bool approved) external;

    //查詢NFT tokenId的操作員位址
    function getApproved(uint256 tokenId)
        external
        view
        returns (address operator);

    //確認_operator位址是否是_owner位址的操作員
    function isApprovedForAll(address owner, address operator)
        external
        view
        returns (bool);
}

interface IERC721Metadata {
    //傳回NFTs的名稱，選用
    function name() external view returns (string memory);

    //傳回NFTs的代稱，選用
    function symbol() external view returns (string memory);

    //傳回NFT _tokenId對應的資源URI，鏈接到Metadata的文件，許多情況會使用 IPFS來儲存
    function tokenURI(uint256 tokenId) external view returns (string memory);
}

interface IERC165 {
    //165 確認介面
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

interface IERC721Receiver {
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
} //介面，確認接收

interface IERC721Enumerable {
    //總發行量
    function totalSupply() external view returns (uint256);

    // 根據_index索引值傳回NFT tokenId
    function tokenOfOwnerByIndex(address owner, uint256 index)
        external
        view
        returns (uint256);

    // 根據_owner位址和_index索引值傳回所有者NFTs列表中的tokenId
    function tokenByIndex(uint256 index) external view returns (uint256);
}

interface IERC721Errors {
    error ERC721InvalidOwner(address owner);
    error ERC721NonexistentToken(uint256 tokenId);
    error ERC721IncorrectOwner(address sender, uint256 tokenId, address owner);
    error ERC721InvalidSender(address sender);
    error ERC721InvalidReceiver(address receiver);
    error ERC721InsufficientApproval(address operator, uint256 tokenId);
    error ERC721InvalidApprover(address approver);
    error ERC721InvalidOperator(address operator);
}

////implement ERC721 ////////////////////

abstract contract ERC721 is
    IERC721,
    IERC721Metadata,
    IERC165,
    IERC721Errors,
    IERC721Enumerable
{
    mapping(address => uint256) balances; //剩餘
    mapping(uint256 => address) owners; //token 主人
    mapping(uint256 => address) tokenApprovals; //授權人
    mapping(address => mapping(address => bool)) operatorApprovals; //Approval是否合法

    address private contractOwner; //合約主人
    string private this_name;
    string private this_symbol;

    mapping(uint256 => string) tokenURIs;

    mapping(address => uint256[]) owners_token;
    uint256[] tokens;

    modifier onlyOwner() {
        require(
            msg.sender == contractOwner,
            "Only contract owner can call this function"
        );

        _;
    }

    constructor(string memory _name, string memory _symbol) {
        this_name = _name; //代幣名稱
        this_symbol = _symbol; //代幣代稱
        contractOwner = msg.sender; //contractOwner = sender
    }

    ////////metadata///////

    function name() public view returns (string memory) {
        return this_name; // 姓名
    }

    function symbol() public view returns (string memory) {
        return this_symbol; // 象徵
    }

    function tokenURI(uint256 tokenId) public view returns (string memory) {
        return tokenURIs[tokenId]; //登記該token id 的url
    }

    function setTokenURI(uint256 tokenId, string memory URI) public {
        address _owner = owners[tokenId]; //設置URI
        require(_owner != address(0), "ERROR: token id is not valid");
        tokenURIs[tokenId] = URI; //設置URI
    }

    /////////////////////////////////

    //傳回_owner位址持有的NFTs數量
    function balanceOf(address owner) public view returns (uint256 balance) {
        require(owner != address(0), "error : address 0 cannot be owner");
        return balances[owner]; //傳回_owner位址持有的NFTs數量
    }

    //根據_tokenId索引值傳回NFT持有者的位址
    function ownerOf(uint256 tokenId) public view virtual returns (address) {
        address _owner = owners[tokenId];
        require(_owner != address(0), "error: tokenId is not valid Id");
        return _owner;
    }

    //從_from位址轉移NFT tokenId的所有權到_to位址，data為附加的參數，觸發Transfer事件
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) public {
        _safeTransfer(from, to, tokenId, data);
    } //安全轉移(附data)

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external {
        _safeTransfer(from, to, tokenId, ""); //安全轉移
    }//安全轉移

    //從_from位址轉移NFT tokenId的所有權到_to位址，觸發Transfer事件
    //執行者負責確認_to位址是否有能力接收NFTs，否則可能永久丟失
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public {
        _transfer(from, to, tokenId);
    }

    //更改或確認NFT的授權位址，_approved 為0表示沒有授權的位址，觸發Approval事件
    function approve(address to, uint256 tokenId) external {
        address _owner = owners[tokenId];
        require(_owner != to, "ERROR: owner == to");
        require(
            _owner == msg.sender || isApprovedForAll(_owner, msg.sender),
            "ERROR: Caller is not token owner / approved for all"
        );
        tokenApprovals[tokenId] = to; //設置、確認授權地址(授權!=所有權)
        emit Approval(_owner, to, tokenId);
    }

    // 啟用或禁用操作員管理，觸發ApprovalForAll事件
    function setApprovalForAll(address operator, bool approved) external {
        require(msg.sender != operator, "ERROR: owner == operator");
        operatorApprovals[msg.sender][operator] = approved; //approved => 操作管理 輸入bool
        emit ApprovalForAll(msg.sender, operator, approved); //這邊要記的切換回contractOwner，不然ban不了
    }

    // 查詢NFT tokenId的授權人(操作人)位址
    function getApproved(uint256 tokenId) public view returns (address) {
        address _owner = owners[tokenId];
        require(_owner != address(0), "ERROR: Token is not minted or is burn");
        return tokenApprovals[tokenId];
    }

    // 確認_operator位址是否是_owner位址的操作員
    function isApprovedForAll(address owner, address operator)
        public
        view
        returns (bool)
    {
        return operatorApprovals[owner][operator]; //在Owner的那個token是否是這位operator
    }

    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) internal {
        address _owner = owners[tokenId];
        require(_owner == from, "ERROR: Owner is not the from address");
        require(
            msg.sender == _owner ||
                isApprovedForAll(_owner, msg.sender) ||
                getApproved(tokenId) == msg.sender,
            "ERROR: Caller doesn't have permission to transfer"
        ); //檢查Caller是否具權限
        
        delete tokenApprovals[tokenId]; //清除代幣操作人
        balances[from] -= 1; //餘額-1
        balances[to] += 1; //餘額 +1
        owners[tokenId] = to; //紀錄擁有id

        rm_tokens_array(owners_token[from], tokenId); //移除owners所屬的token
        owners_token[to].push(tokenId); 
        //增加_to 的id

        emit Transfer(from, to, tokenId); 
        //觸發Transfer 事件
    }

    function _safeTransfer(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) internal {
        _transfer(from, to, tokenId); //轉移token
        _checkOnERC721Received(from, to, tokenId, data); //確認安全
    }

    //////////////////////////////////////////

    function _mint(address to, uint256 tokenId) internal {
        require(to != address(0), "ERROR: Mint to address 0");
        address _owner = owners[tokenId]; //2/ 抓取此貨幣擁有人
        require(_owner == address(0), "ERROR: tokenId existed"); //此貨幣已擁有則，則不為0
        balances[to] += 1; //餘額++
        owners[tokenId] = to; //登記使用者已擁有
        /////////////
        owners_token[to].push(tokenId); //_owner 代幣增加
        tokens.push(tokenId); //代幣id增加
        ////////////
        emit Transfer(address(0), to, tokenId);
        //發行貨幣//////
    }

    function _safeMint(address to, uint256 tokenId) internal {
        _safeMint(to, tokenId, ""); //安全發行
    }

    function _safeMint(
        address to,
        uint256 tokenId,
        bytes memory data
    ) internal virtual {
        _mint(to, tokenId);
        data; //兩者不同，一個有virtual
    }

    function _burn(uint256 tokenId) internal {
        address _owner = owners[tokenId]; //登記貨幣
        require(msg.sender == _owner, "ERROR: only owner can burn"); // 只有擁有者可銷毀
        balances[_owner] -= 1; //餘額-1
        delete owners[tokenId]; //刪除此幣
        delete tokenApprovals[tokenId]; //刪除授權登記
        ///////burn => 銷毀在owner下的列，以及
        rm_tokens_array(owners_token[_owner], tokenId);
        rm_tokens_array(tokens, tokenId);
        ///////
        emit Transfer(_owner, address(0), tokenId);
        // 銷毀貨幣
    }

    ////////////////IERC721Enumerable/////////////////////////

    function see_owners_have(address _owner)
        public
        view
        returns (uint256[] memory)
    {
        return owners_token[_owner];
    }

    // for test,see how many token for owners

    function totalSupply() external view returns (uint256 token_length) {
        return tokens.length;
    } // total token

    function tokenOfOwnerByIndex(address _owner, uint256 _index)
        external
        view
        returns (uint256 tokenId)
    {
        return owners_token[_owner][_index];
    } //this index in this owner , which tokenId

    function tokenByIndex(uint256 _index)
        external
        view
        returns (uint256 tokenId)
    {
        return tokens[_index];
    }

    function rm_tokens_array(uint256[] storage _arr, uint256 tokenId) internal {
        uint256 length = _arr.length;
        for (uint256 i = 0; i < length; i++) {
            if (_arr[i] == tokenId) { //不要的換到最後，再pop掉
                _arr[i] = _arr[length - 1];
                break;
            }
        }
        _arr.pop();
    }

    ///////IERC165///////////////////////////////////////

    // 合約是否實現了interface，若合約實現了interfaceID並且interfaceID不是0xffffffff則傳回true，
    // 否則傳回false
    // 函數要少於30,000 gas
    function supportsInterface(bytes4 interfaceId)
        external
        pure
        returns (bool)
    {
        require((interfaceId != 0xffffffff), "invalid interface id");
        return
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId ||
            interfaceId == type(IERC165).interfaceId;
    }

    /////////////////////////////
    function _checkOnERC721Received(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) private {
        if (to.code.length > 0) {
            try
                IERC721Receiver(to).onERC721Received(
                    msg.sender,
                    from,
                    tokenId,
                    data
                )
            returns (bytes4 retval) {
                if (retval != IERC721Receiver.onERC721Received.selector) {
                    revert ERC721InvalidReceiver(to);
                }
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert ERC721InvalidReceiver(to);
                } else {
                    /// @solidity memory-safe-assembly
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        }
    }

    /////////////////////////////
}

////////////MyToken///////////////////////////

////////////實例出來////////////////////////

contract MyToken is ERC721 {
    // _name, _symbol
    // Time is money !!!!!!!!!
    constructor() ERC721("TIME", "$$$") {}

    function mint(address to, uint256 tokenId) public onlyOwner {
        // _mint(to, tokenId); //使可以直接發行與銷毀、來進行測試
        _mint(to, tokenId); //使可以直接發行與銷毀、來進行測試
    }

    function burn(uint256 tokenId) public onlyOwner {
        _burn(tokenId); //銷毀
    }
}
