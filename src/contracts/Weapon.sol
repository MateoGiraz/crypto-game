//SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import "../interfaces/IWeapon.sol";

/// @dev This contract must implement the IWeapon interface
contract Weapon is IWeapon {
    function name() external view override returns (string memory _name) {}

    function symbol() external view override returns (string memory _symbol) {}

    function tokenURI()
        external
        view
        override
        returns (string memory _tokenURI)
    {}

    function totalSupply() external view override returns (uint256) {}

    function balanceOf(
        address _owner
    ) external view override returns (uint256) {}

    function ownerOf(
        uint256 _tokenId
    ) external view override returns (address) {}

    function allowance(
        uint256 _tokenId
    ) external view override returns (address) {}

    function safeTransfer(address _to, uint256 _tokenId) external override {
    }

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external override {}

    function approve(address _approved, uint256 _tokenId) external override {}

    function metadataOf(
        uint256 _tokenId
    ) external view override returns (Metadata memory _metadata) {}

    function characterContract()
        external
        view
        override
        returns (address _characterContract)
    {}

    function safeMint(string memory _name) external override {}

    function mintLegendaryWeapon(
        uint256 _attackPoints,
        uint256 _armorPoints,
        uint256 _sellPrice,
        uint256 _requiredExperience
    ) external override {}

    function getSellInformation(
        uint256 _tokenId
    )
        external
        view
        override
        returns (bool _onSale, uint256 _price, uint256 _requiredExperience)
    {}

    function buy(uint256 _tokenId, string memory _newName) external override {}

    function setOnSale(uint256 _tokenId, bool _onSale) external override {}

    function currentTokenID()
        external
        view
        override
        returns (uint256 _currentTokenID)
    {}

    function mintPrice() external view override returns (uint256 _mintPrice) {}

    function setMintPrice(uint256 _mintPrice) external override {}

    function collectFee() external override {}

    function addWeaponToCharacter(
        uint256 _weaponId,
        uint256 _characterId
    ) external override {}

    function removeWeaponFromCharacter(
        uint256 _weaponId,
        uint256 _characterId
    ) external override {}
}