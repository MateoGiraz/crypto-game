//SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import "../interfaces/IExperience.sol";
import "../interfaces/IOwnersContract.sol";
import "../interfaces/IERC721TokenReceiver.sol";

contract Experience is IExperience {

    uint256 public constant MAX_INTEGER = 2**256 - 1;
    uint256 public constant TOKEN_DECIMALS  = 18;

    string Name;
    string Symbol;
    uint256 Price;
    address OwnersContract;
    uint256 private _totalSupply;

    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;

    constructor(string memory _name, string memory _symbol, address _ownersContract) {
        _totalSupply = 0;
        Name = _name;
        Symbol = _symbol;
        OwnersContract = _ownersContract;
        Price = MAX_INTEGER;
    }
    function name() external view override returns (string memory _name) {
        _name = Name;
    }

    function symbol() external view override returns (string memory _symbol) {
        _symbol = Symbol;
    }

    function decimals() external view override returns (uint256 _decimals) {
        _decimals = TOKEN_DECIMALS;
    }

    function totalSupply() external view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address _owner) external view override returns (uint256) {
        return balances[_owner];
    }

    function allowance(
        address _owner,
        address _spender
    ) external view override returns (uint256 _amount) {
        _amount = allowed[_owner][_spender];
    }

    function safeTransfer(address _to, uint256 _value) 
    external override 
    isValidAddress(_to, "Invalid address")
    isDifferentSenderAndRemittent(msg.sender, _to)
    validValue(_value)
    enoughBalance(msg.sender, _value)
    returns (bool result) {
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        _checkERC721Receiver(_to, 0);
        result = true;
    }

    /// @dev Throw if msg.sender is not the current owner or an approved address with permission to spend 
    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _value
    ) external override
    isValidAddress(_from, "Invalid _from address")
    isValidAddress(_to, "Invalid _to address")
    isDifferentSenderAndRemittent(_from, _to)
    validValue(_value)
    enoughBalance(_from, _value)
    returns (bool result){
        require(allowed[_from][msg.sender] >= _value, "Insufficent allowance");
        balances[_from] -= _value;
        balances[_to] += _value;
        allowed[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        _checkERC721Receiver(_to, 0);
        result = true;
    }

    function approve(address _spender, uint256 _value) 
    external override
    firstTimeSetOrCero(_value, _spender)
    isValidAddress(_spender, "Invalid _spender")
    validValue(_value)
    enoughBalance(msg.sender, _value)
    {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
    }

    function price() external view override returns (uint256 _price) {
        _price = Price;
    }

    /// @notice Issue a number of tokens in exchange of a number of Rubies tokens
    /// Perform the validations in the indicated order:
    /// @dev Throw if sender don't have enough Rubies to cover the price of the tokens to buy. Message: "Insufficient balance"
    /// @dev Throw if the contract don't have enough allowance to cover the price of the tokens to buy. Message: "Insufficient allowance"
    /// @dev Increase the sell price of the user charater for the 10% of the price.
    /// @dev Increase the armor points of the user charater in 10% of the experience buyed.
    /// @dev Increase the weapon points of the user charater in 5% of the experience buyed.  
    /// @dev Emit the Transfer event with the corresponding parameters.
    /// @param _amount It is the amount of tokens to buy
    function buy(uint256 _amount) 
    external override {}

    function setPrice(uint256 _price) external onlyOwners override {
        require(_price > 0, "Invalid _price");
        Price = _price;
    }

    /// events 

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    
    /// modifiers

    modifier onlyOwners() {
        require(IOwnersContract(OwnersContract).owners(msg.sender), "Not the owner");
        _;
    }

    modifier isValidAddress(address _address, string memory message) {
        require(_address != address(0), message);
        _;
    }

    modifier isDifferentSenderAndRemittent(address _from, address _to) {
        require(_from != _to, "Invalid recipient, same as remittent");
        _;
    }

    modifier validValue(uint256 _value) {
        require(_value > 0, "Invalid _value");
        _;
    }

    modifier enoughBalance(address _addr, uint256 _value) {
        require(balances[_addr] >= _value, "Insufficient balance");
        _;
    }

    modifier firstTimeSetOrCero(uint256 _value, address _spender) {
        require(
            _value == 0 || allowed[msg.sender][_spender] == 0,
            "Invalid allowance amount. Set to zero first"
        );
        _;
    }

    /// private functions

    function _isSmartContract(address _addr) private view returns (bool) {
        return _addr.code.length > 0;
    }

    function _checkERC721Receiver(address _addr, uint256 _tokenId) private {
        if (_isSmartContract(_addr)) {
            bytes4 ERC721_TokenReceiver_Hash = 0x150b7a02;
            bytes memory data;
            bytes4 ERC721_Received = IERC721TokenReceiver(_addr)
                .onERC721Received(msg.sender, _addr, _tokenId, data);
            require(
                ERC721_Received == ERC721_TokenReceiver_Hash,
                "Invalid contract"
            );
        }
    }
}