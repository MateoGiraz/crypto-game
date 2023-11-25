//SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import "../interfaces/IOwnersContract.sol";

contract OwnersContract is IOwnersContract {

    uint256 ownersCount;
    uint256 tokenFeePercentage;
    address[] private _ownersRegistred;
    mapping (string => address) addresses;
    mapping (address => bool) areOwners;
    mapping (address => uint256) balances;

    constructor(uint256 _tokenSellFeePercentage) {
        areOwners[msg.sender] = true;
        ownersCount = 1;
        _ownersRegistred.push(msg.sender);
        tokenFeePercentage = _tokenSellFeePercentage;
    }

    function ownerIndex() external view override returns (uint256 _ownerIndex){
        _ownerIndex = ownersCount;
    }

    function tokenSellFeePercentage() external view override
        returns (uint256 _tokenSellFee)
    {
        _tokenSellFee = tokenFeePercentage;
    }
    
    function owners(address _ownerAddress) external view override returns (bool _isOwner) {
        _isOwner = areOwners[_ownerAddress];
    }

    function ownersList(uint256 _ownerIndex) external view override returns (address _ownerAddress) {
        if (_ownerIndex > ownersCount) {
            _ownerAddress = address(0x0);
        }
        else {
            _ownerAddress = _ownersRegistred[_ownerIndex];
        }
    }

    function addressOf(
        string memory _contractName
    ) external view override returns (address _contractAddress) {
        _contractAddress = addresses[_contractName];
    }

    function balanceOf(
        address _ownerAddress
    ) external view override returns (uint256 _ownerBalance) {
        _ownerBalance = _ownerAddress.balance;
    }

    function addOwner(address _newOwner) external override onlyOwner(msg.sender) {
        require(!areOwners[_newOwner], "The address is already an owner");
        require(_newOwner != address(0x0), "The address is not valid");
        areOwners[_newOwner] = true;
        ownersCount++;
        _ownersRegistred.push(_newOwner);
    }

    function addContract(
        string memory _contractName,
        address _contract
    ) external override 
    onlyOwner(msg.sender)
    {
        require(addresses[_contractName] == address(0x0), "The contract name is already in use");
        require(_contract != address(0x0), "The contract address is not valid");
        
        addresses[_contractName] = _contract;
    }

    function collectFeeFromContract(
        string memory _contractName
    ) external override 
    onlyOwner(msg.sender) 
    {
        require(addresses[_contractName] != address(0x0), "The contract name is not valid");
        require(addresses[_contractName].balance > 0, "zero balance");

        uint256 fee = addresses[_contractName].balance / ownersCount;
        for (uint256 i = 0; i < ownersCount; i++) {
            balances[_ownersRegistred[i]] += fee;
            emit Withdraw(_ownersRegistred[i], fee);
        }
    }
    
    function WithdrawEarnings() external override 
    onlyOwner(msg.sender) 
    _isEOA(msg.sender) 
    {
        payable(msg.sender).transfer(balances[msg.sender]);
        balances[msg.sender] = 0;

        emit Transfer(msg.sender, balances[msg.sender]);
    }

    /// events

    event Withdraw(address indexed _to, uint256 _value);
    event Transfer(address indexed _to, uint256 _value);

    /// modifiers

    modifier _isEOA(address _address) {
        require(_address.code.length == 0, "Invalid operation for smart contracts");
        _;
    }

    modifier onlyOwner(address _address) {
        require(areOwners[_address], "Not the owner");
        _;
    }
}