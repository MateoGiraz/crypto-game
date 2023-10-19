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
      return _owners.length - 1;
    }

    function tokenSellFeePercentage() external view override returns (uint256 _tokenSellFee){
      return _tokenSellFeePercentage;
    }

    function owners(
        address _ownerAddress
    ) external view override returns (bool _isOwner) {
      for (uint256 i = 0; i < _owners.length; i++) {
        if (_owners[i] == _ownerAddress) {
          return true;
        }
      }
      return false;
    }

    function ownersList(
        uint256 _ownerIndex
    ) external view override returns (address _ownerAddress) {
      return _owners[_ownerIndex];
    }

    function addressOf(
        string memory _contractName
    ) external view override returns (address _contractAddress) {
      return contracts[_contractName];
    }

    function balanceOf(
        address _ownerAddress
    ) external view override returns (uint256 _ownerBalance) {
      return ownerBalances[_ownerAddress];
    }

    function addOwner(address _newOwner) external override {
      _owners.push(_newOwner);
    }

    function addContract(
        string memory _contractName,
        address _contract
    ) external override {
      contracts[_contractName] = _contract;
    }

    /// @dev Withdraw to this contract the ethers locked in each contract for the fees charged.
    /// The amount received is divided equally among all owners currently listed on the contract and added to 
    /// the balance that each owner can withdraw
    /// @dev In the event that the Land contract does not have ethers, revert with the message "zero balance"
    function collectFeeFromContract(
        string memory _contractName
    ) external override {
      address contractAddress = contracts[_contractName];
      uint256 amount = 0;//IProtocol(contractAddress).withdrawFees();
      require(amount > 0, "zero balance");
      uint256 amountPerOwner = amount / _owners.length;
      for (uint256 i = 0; i < _owners.length; i++) {
        ownerBalances[_owners[i]] += amountPerOwner;
      }
      
    }

    function WithdrawEarnings() external override {
      require(msg.sender == tx.origin, "Invalid operation for smart contracts");
      uint256 amount = ownerBalances[msg.sender];
      ownerBalances[msg.sender] = 0;
      payable(msg.sender).transfer(amount);
    }
}