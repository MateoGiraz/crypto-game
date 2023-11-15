//SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import "../interfaces/ICharacter.sol";

/// @dev This contract must implement the ICharacter interface
contract Character is ICharacter {
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

    function safeTransfer(address _to, uint256 _tokenId) external override {}

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external override {}

    function approve(address _approved, uint256 _tokenId) external override {}

    function metadataOf(
        uint256 _tokenId
    ) external view override returns (Metadata memory _metadata) {}

    function weapon(
        uint256 _weaponIndex
    ) external view override returns (IWeapon _weapon) {}

    function safeMint(string memory _name) external override {}

    function mintHero(
        uint256 _attackPoints,
        uint256 _armorPoints,
        IWeapon[3] memory _weapon,
        uint256 _sellPrice,
        uint256 _requiredExperience
    ) external override {}

    function getSellinformation(
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

    function setMintingPrice(uint256 _mintPrice) external override {}

    function collectFee() external override {}
}