//SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import "../interfaces/IExperience.sol";
import "../interfaces/IOwnersContract.sol";
import "../interfaces/IRubie.sol";
import "../interfaces/ICharacter.sol";
import "../interfaces/IERC721TokenReceiver.sol";

contract Experience is IExperience {

    uint256 public constant MAX_INTEGER = 2**256 - 1;
    uint256 public constant TOKEN_DECIMALS  = 18;

    string Name;
    string Symbol;
    uint256 Price;
    address OwnersContract;
    uint256 _totalSupply;

    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;

    constructor(string memory _name, string memory _symbol, address _ownersContract) isValidName(_name) {
        require(bytes(_symbol).length == 3, "Invalid Symbol");
        _totalSupply = 0;
        Name = _name;
        Symbol = _symbol;
        OwnersContract = _ownersContract;
        Price = 1;
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
        result = true;
    }

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
        require(_from == msg.sender || allowed[_from][msg.sender] >= _value, "Insufficent allowance");
        balances[_from] -= _value;
        balances[_to] += _value;
        allowed[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
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

    /*function buy(uint256 _amount) external override {
        address rubieAddress = IOwnersContract(OwnersContract).addressOf("Rubie");
        IRubie rubieContract = IRubie(rubieAddress);

        uint totalPrice = Price * _amount;
        require(rubieContract.balanceOf(msg.sender) >= totalPrice, "Insufficient balance");
        /// @dev Throw if the contract don't have enough allowance to cover the price of the tokens to buy. Message: "Insufficient allowance"
        address characterAddress = IOwnersContract(OwnersContract).addressOf("Character");
        ICharacter characterContract = ICharacter(characterAddress);
        uint256 _characterId = characterContract.ownedBy(msg.sender);

        uint256 sellPrice = totalPrice /10;
        uint256 armorPoints = _amount /10;
        uint256 attackPoints = _amount /20;

        characterContract.upgradeStats(_characterId, attackPoints, armorPoints, sellPrice);
        rubieContract.safeTransferFrom(msg.sender, address(this), totalPrice);
        balances[msg.sender] += _amount;

        emit Transfer(msg.sender, address(this), _amount);
    }*/

    function buy(uint256 _amount) external override {
    address rubieAddress = IOwnersContract(OwnersContract).addressOf("Rubie");
    IRubie rubieContract = IRubie(rubieAddress);

    uint256 totalPrice = Price * _amount;
    require(rubieContract.balanceOf(msg.sender) >= totalPrice, "Insufficient balance");

    // Calcular la comisión
    uint256 commission = calculateCommission(totalPrice); // Esta función calculará la comisión
    uint256 amountAfterCommission = totalPrice - commission;

    address characterAddress = IOwnersContract(OwnersContract).addressOf("Character");
    ICharacter characterContract = ICharacter(characterAddress);
    uint256 _characterId = characterContract.ownedBy(msg.sender);

    uint256 sellPrice = amountAfterCommission / 10;
    uint256 armorPoints = _amount / 10;
    uint256 attackPoints = _amount / 20;

    characterContract.upgradeStats(_characterId, attackPoints, armorPoints, sellPrice);
    rubieContract.safeTransferFrom(msg.sender, address(this), amountAfterCommission);

    // Aumentar el balance de Experience por la comisión
    balances[address(this)] += commission;

    balances[msg.sender] += _amount;

    emit Transfer(msg.sender, address(this), _amount);
}

// Función para calcular la comisión
function calculateCommission(uint256 amount) private view returns (uint256) {
    uint256 commissionPercentage = IOwnersContract(OwnersContract).tokenSellFeePercentage();
    return (amount * commissionPercentage) / 100;
}


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
        require(_value >= 0, "Invalid _value");
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

    modifier isValidName(string memory name) {
        require(bytes(name).length > 0, "Invalid _name");
        _;
    }

    /// private functions

    function _isSmartContract(address _addr) private view returns (bool) {
        return _addr.code.length > 0;
    }

    function _checkERC721Receiver(address _addr, uint256 _tokenId) private {
        if (false/* TODO _isSmartContract(_addr)*/ ) {
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

    function mintForTesting(address _to, uint256 _amount) external {
    balances[_to] += _amount;
    _totalSupply += _amount;
    emit Transfer(address(0), _to, _amount);
    }
}