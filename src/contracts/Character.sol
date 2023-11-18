//SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

/// @dev This contract must implement the ICharacter interface
import "../interfaces/ICharacter.sol";

contract Character is ICharacter {
    string Name;
    string Symbol;
    string TokenURI;
    address OwnersContract;
    uint256 private _totalSupply;
    mapping(address => uint256) balances;
    mapping(address => mapping(uint256 => address)) allowed;
    mapping(uint256 => Metadata) metadatas;
    mapping(uint256 => IWeapon) weapons;

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _tokenURI,
        address _ownersContract
    ) {
        Name = _name;
        Symbol = _symbol;
        TokenURI = _tokenURI;
        OwnersContract = _ownersContract;
        _totalSupply = 0;
    }

    function name() external view override returns (string memory _name) {
        _name = Name;
    }

    function symbol() external view override returns (string memory _symbol) {
        _symbol = Symbol;
    }

    function tokenURI()
        external
        view
        override
        returns (string memory _tokenURI)
    {
        _tokenURI = TokenURI;
    }

    function totalSupply() external view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(
        address _owner
    ) external view override returns (uint256) {
        return balances[_owner];
    }

    function ownerOf(
        uint256 _tokenId
    ) external view override returns (address) {
        return OwnersContract;
    }

    function allowance(
        uint256 _tokenId
    ) external view override returns (address) {
        return allowed[OwnersContract][_tokenId];
    }

    function safeTransfer(address _to, uint256 _tokenId) external override {
        require(_to != address(0), "Invalid _to address");
        require(_to != msg.sender, "Invalid recipient, same as remittent");
        require(_tokenId > 0, "Invalid _tokenId");
        require(balances[msg.sender] >= _tokenId, "Insufficient balance");
        require(
            allowed[OwnersContract][_tokenId] == msg.sender,
            "Not authorized"
        );
        balances[msg.sender] -= _tokenId;
        balances[_to] += _tokenId;
        //emit Transfer(msg.sender, _to, _tokenId);
    }

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external override {
        require(_from != address(0), "Invalid _from address");
        require(_to != address(0), "Invalid _to address");
        require(_to != _from, "Invalid recipient, same as remittent");
        require(_tokenId > 0, "Invalid _tokenId");
        require(balances[_from] >= _tokenId, "Insufficient balance");
        balances[_from] -= _tokenId;
        balances[_to] += _tokenId;
        //emit Transfer(_from, _to, _tokenId);
    }

    function approve(address _approved, uint256 _tokenId) external override {
        require(_approved != address(0), "Invalid _approved");
        require(_tokenId > 0, "Invalid _tokenId");
        require(
            _tokenId == 0 || allowed[OwnersContract][_tokenId] == address(0),
            "Invalid allowance amount. Set to zero first"
        );
        require(_approved != address(0), "Invalid _approved");
        require(balances[OwnersContract] >= _tokenId, "Insufficient balance");
        allowed[OwnersContract][_tokenId] = _approved;
        //emit Approval(OwnersContract, _approved, _tokenId);
    }

    function metadataOf(
        uint256 _tokenId
    ) external view override returns (Metadata memory _metadata) {
        _metadata = metadatas[_tokenId];
    }

    function weapon(
        uint256 _weaponIndex
    ) external view override returns (IWeapon _weapon) {
        _weapon = weapons[_weaponIndex];
    }

    function safeMint(string memory _name) external override {}

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

    function mintHero(
        uint256 _attackPoints,
        uint256 _armorPoints,
        uint256[3] memory _weapon,
        uint256 _sellPrice,
        uint256 _requiredExperience
    ) external override {
        require(_attackPoints >= 100, "Invalid _attackPoints");
        require(_armorPoints >= 50, "Invalid _armorPoints");
        require(_sellPrice > 0, "Invalid _sellPrice");
        require(_requiredExperience >= 100, "Invalid _requiredExperience");
    }
}

