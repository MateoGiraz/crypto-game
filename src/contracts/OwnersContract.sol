//SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import "../interfaces/IOwnersContract.sol";

/// @dev This contract must implement the IOwnersContract interface
contract OwnersContract is IOwnersContract {
    uint256 private _tokenSellFeePercentage;
    address[] private _owners;
    mapping(address => uint256) private ownerBalances;
    mapping(string => address) private contracts;

    constructor(uint256 _initialTokenSellFeePercentage) {
        _tokenSellFeePercentage = _initialTokenSellFeePercentage;
        _owners.push(msg.sender);
    }

    function ownerIndex() external view override returns (uint256 _ownerIndex){

    }

    function tokenSellFeePercentage() external view override returns (uint256 _tokenSellFee){

    }

    function owners(
        address _ownerAddress
    ) external view override returns (bool _isOwner) {

    }

    function ownersList(
        uint256 _ownerIndex
    ) external view override returns (address _ownerAddress) {

    }

    function addressOf(
        string memory _contractName
    ) external view override returns (address _contractAddress) {}

    function balanceOf(
        address _ownerAddress
    ) external view override returns (uint256 _ownerBalance) {

    }

    function addOwner(address _newOwner) external override {

    }

    function addContract(
        string memory _contractName,
        address _contract
    ) external override {

    }

    function collectFeeFromContract(
        string memory _contractName
    ) external override {

    }

    function WithdrawEarnings() external override {
      
    }
}