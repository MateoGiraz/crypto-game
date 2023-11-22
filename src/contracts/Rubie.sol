//SPDX-License-Identifier: MIT
pragma solidity 0.8.16;



import "../interfaces/IRubie.sol";

/// @dev This contract must implement the IRubie interface
contract Rubie is IRubie{
    string Name;
    uint256 public constant MAX_INTEGER = 2**256 - 1;
    string Symbol;
    address ownersContract;
    uint256 private _totalSupply;
    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;
    uint256  Actualprice;

    string Name;
    uint256 public constant MAX_INTEGER = 2**256 - 1;
    string Symbol;
    address ownersContract;
    uint256 private _totalSupply;
    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;
    uint256  Actualprice;

    constructor(string memory _name, string memory _symbol, address
_ownersContract) {
        Name = _name;
        Symbol = _symbol;
        ownersContract = _ownersContract;
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

    function balanceOf(
        address _owner
    ) external view override returns (uint256) {
        return balances[_owner];
    }

    function allowance(
        address _owner,
        address _spender
    ) external view override returns (uint256 _amount) {
        _amount = allowed[_owner][_spender];
    }


    ///Falta  el segundo dev y que trigerree  Transfer
    function safeTransfer(address _to, uint256 _value) external override {
        require(_to != address(0), "Invalid _to address");
        require(_to != _to, "Invalid recipient, same as remittent");
        require(_value > 0, "Invalid value");
        require(balances[msg.sender] >= _value, "Insufficient balance");
        balances[msg.sender] -= _value;
        balances[_to] += _value;
<<<<<<< Updated upstream
        
=======
>>>>>>> Stashed changes
    }

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _value
    ) external override {
        require(_from != address(0), "Invalid _from address");
        require(_to != address(0), "Invalid _to address");
        require(_to != _from, "Invalid recipient, same as remittent");
        require(_value > 0, "Invalid value");
        require(balances[_from] >= _value, "Insufficient balance");
        require(allowed[_from][msg.sender] >= _value, "Insufficent allowance");
        balances[_from] -= _value;
        balances[_to] += _value;
    }

    ///No se checkear si se llama multiples veces
    //falta que triggeree approval
    function approve(address _spender, uint256 _value) external override {
        require(_spender != address(0), "Invalid _spender");
        require(_value > 0, "Invalid value");
        require(_value == 0 || allowed[msg.sender][_spender] == 0, "Invalid allowance amount. Set to zero first");
        require(_spender != address(0), "Invalid _spender");
        require(balances[msg.sender] >= _value, "Insufficient balance");
        allowed[msg.sender][_spender] = _value;
    }

    modifier onlyOwners() {
        require(msg.sender == ownersContract, "Not the owner");
        _;
    }
    /// Hay que fijarse como hacemos por si no tiene un precio inicial
    function price() external view override returns (uint256 _price) {
        _price = Actualprice;
    }

    ///Falta el trigger de Emit
    function mint(uint256 _amount, address _recipient) external onlyOwners override {
        require(_amount > 0, "Invalid _amount");
        require(_recipient != address(0), "Invalid _recipient");
        _totalSupply += _amount;
        balances[_recipient] += _amount;
    }

    function buy(uint256 _amount) external payable override 
    {
        require(msg.value >= Actualprice * _amount, "Insufficient ether");
        if (msg.value > Actualprice * _amount) {
            payable(msg.sender).transfer(msg.value - Actualprice * _amount);
        }
        _totalSupply += _amount;
        balances[msg.sender] += _amount;
    }

    function setPrice(uint256 _price) external onlyOwners override {
        require(_price > 0, "Invalid _price");
        Actualprice = _price;
    }
}