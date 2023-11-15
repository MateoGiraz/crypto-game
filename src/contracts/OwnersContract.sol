//SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

/// @dev This contract must implement the IOwnersContract interface

import "../interfaces/IOwnersContract.sol";

contract OwnersContract is IOwnersContract {
    function ownerIndex()
        external
        view
        override
        returns (uint256 _ownerIndex)
    {}

    function tokenSellFeePercentage()
        external
        view
        override
        returns (uint256 _tokenSellFee)
    {}

    function owners(
        address _ownerAddress
    ) external view override returns (bool _isOwner) {}

    function ownersList(
        uint256 _ownerIndex
    ) external view override returns (address _ownerAddress) {}

    function addressOf(
        string memory _contractName
    ) external view override returns (address _contractAddress) {}

    function balanceOf(
        address _ownerAddress
    ) external view override returns (uint256 _ownerBalance) {}

    function addOwner(address _newOwner) external override {}

    function addContract(
        string memory _contractName,
        address _contract
    ) external override {}

    function collectFeeFromContract(
        string memory _contractName
    ) external override {}

    function WithdrawEarnings() external override {}
}