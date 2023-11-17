//SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import "../interfaces/IOwnersContract.sol";

/// @dev This contract must implement the IOwnersContract interface

import "../interfaces/IOwnersContract.sol";

contract OwnersContract is IOwnersContract {

    mapping (address => bool) ownersMap;
    uint256 ownersCount;
    uint256 tokenFeePercentage;
    address[] private _ownersRegistred;
    mapping (string => address) Addresses;


    constructor(uint256 _tokenSellFeePercentage) {
        ownersMap[msg.sender] = true;
        ownersCount = 1;
        _ownersRegistred.push(msg.sender);
        tokenFeePercentage = _tokenSellFeePercentage;
    }

    function ownerIndex() external view override returns (uint256 _ownerIndex){
        _ownerIndex = ownersCount;
    }
    /// Preguntar
    function tokenSellFeePercentage() external view override
        returns (uint256 _tokenSellFee)
    {
        _tokenSellFee = tokenFeePercentage;
    }

    
    function owners(address _ownerAddress) external view override returns (bool _isOwner) {
        _isOwner = ownersMap[_ownerAddress];
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
        _contractAddress = Addresses[_contractName];
    }

    function balanceOf(
        address _ownerAddress
    ) external view override returns (uint256 _ownerBalance) {
        _ownerBalance = _ownerAddress.balance;
    }

    function addOwner(address _newOwner) external override {
        require(ownersMap[msg.sender], "Only owners can add new owners");
        require(!ownersMap[_newOwner], "The address is already an owner");
        require(_newOwner != address(0x0), "The address is not valid");
        ownersMap[_newOwner] = true;
        ownersCount++;
        _ownersRegistred.push(_newOwner);
    }

    function addContract(
        string memory _contractName,
        address _contract
    ) external override {
        require(ownersMap[msg.sender], "Only owners can add new contracts");
        require(Addresses[_contractName] == address(0x0), "The contract name is already in use");
        require(_contract != address(0x0), "The contract address is not valid");
        Addresses[_contractName] = _contract;
    }

    function collectFeeFromContract(
        string memory _contractName
    ) external override  {
        require(ownersMap[msg.sender], "Only owners can collect fees");
        require(Addresses[_contractName] != address(0x0), "The contract name is not valid");
        require(Addresses[_contractName].balance > 0, "zero balance");
        uint256 fee = Addresses[_contractName].balance / ownersCount;
        for (uint256 i = 0; i < ownersCount; i++) {
            payable(_ownersRegistred[i]).transfer(fee);
        }
    }
    
    /// No tengo ni idea
    function WithdrawEarnings() external override {
    }
}