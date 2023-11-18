//SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

/// @dev This contract must implement the IExperience interface
import "../interfaces/IExperience.sol";

contract Experience is IExperience {
    function name() external view override returns (string memory _name) {}

    function symbol() external view override returns (string memory _symbol) {}

    function decimals() external view override returns (uint256 _decimals) {}

    function totalSupply() external view override returns (uint256) {}

    function balanceOf(address _owner) external view override returns (uint256) {

    
    }

    function allowance(
        address _owner,
        address _spender
    ) external view override returns (uint256 _amount) {}

    function safeTransfer(address _to, uint256 _value) external override {}

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _value
    ) external override {}

    function approve(address _spender, uint256 _value) external override {}

    function price() external view override returns (uint256 _price) {}

    function buy(uint256 _amount) external override {}

    function setPrice(uint256 _price) external override {}
}