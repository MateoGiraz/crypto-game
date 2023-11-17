//SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

/// @dev This contract must implement the IExperience interface
import "../interfaces/IExperience.sol";

contract Experience is IExperience {

    uint256 public constant MAX_INTEGER = 2**256 - 1;
    string Name;
    string Symbol;
    address OwnersContract;
    uint256 private _totalSupply;
    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;
    uint256  Actualprice;

    constructor(string memory _name, string memory _symbol, address _ownersContract) {
        Name = _name;
        Symbol = _symbol;
        OwnersContract = _ownersContract;
        _totalSupply = 0;
        Actualprice = MAX_INTEGER;
    }
    function name() external view override returns (string memory _name) {
        _name = Name;
    }

    function symbol() external view override returns (string memory _symbol) {
        _symbol = Symbol;
    }

    function decimals() external view override returns (uint256 _decimals) {
        _decimals = 18;
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

    function isContract(address _addr) internal view returns (bool is_contract) {
        uint256 length;
        assembly {
            length := extcodesize(_addr)
        }
        is_contract = (length > 0);
    }

    ///fijarse si es un contract o no
    function safeTransfer(address _to, uint256 _value) external override returns (bool result) {
        require(_to != address(0), "Invalid _to address");
        require(_to != msg.sender, "Invalid recipient, same as remittent");
        require(_value > 0, "Invalid _value");
        require(balances[msg.sender] >= _value, "Insufficient balance");
        
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        //emit Transfer(msg.sender, _to, _value);//Me lo tiro gpt no se si esta bien
        result = true;
    }

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _value
    ) external override returns (bool result){
        require(_from != address(0), "Invalid _from address");
        require(_to != address(0), "Invalid _to address");
        require(_to != _from, "Invalid recipient, same as remittent");
        require(_value > 0, "Invalid _value");
        require(balances[_from] >= _value, "Insufficient balance");
        require(allowed[_from][msg.sender] >= _value, "Insufficient allowance");
        balances[_from] -= _value;
        balances[_to] += _value;
        allowed[_from][msg.sender] -= _value;
        //emit Transfer(_from, _to, _value);//Me lo tiro gpt no se si esta bien
        result = true;
    }

    function approve(address _spender, uint256 _value) external override {
        require(_spender != address(0), "Invalid _spender");
        require(_value > 0, "Invalid _value");
        require(_value == 0 || allowed[msg.sender][_spender] == 0, "Invalid allowance amount. Set to zero first");
        require(_spender != address(0), "Invalid _spender");
        require(balances[msg.sender] >= _value, "Insufficient balance");
        allowed[msg.sender][_spender] = _value;
        //emit Approval(msg.sender, _spender, _value);//Me lo tiro gpt no se si esta bien
    }

    modifier onlyOwners() {
        require(msg.sender == OwnersContract, "Not the owner");
        _;
    }

    function price() external view override returns (uint256 _price) {
        _price = Actualprice;
    }

    function buy(uint256 _amount) external override {
        require(_amount > 0, "Invalid _amount");
        require(Actualprice != MAX_INTEGER, "Invalid price");
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        require(allowed[msg.sender][OwnersContract] >= _amount, "Insufficient allowance");
        balances[msg.sender] -= _amount;
        balances[OwnersContract] += _amount;
        allowed[msg.sender][OwnersContract] -= _amount;
        //emit Transfer(msg.sender, OwnersContract, _amount);//Me lo tiro gpt no se si esta bien
    }

    function setPrice(uint256 _price) external onlyOwners override {
        require(_price > 0, "Invalid _price");
        Actualprice = _price;
    }
}