//SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

/// @dev This contract must implement the ICharacter interface
import "../interfaces/ICharacter.sol";
import "../interfaces/IRubie.sol";
import "../interfaces/IERC721TokenReceiver.sol";

contract Character is ICharacter {
    string Name;
    string Symbol;
    string TokenURI;
    address OwnersContract;
    address RubiesContract;
    uint256 MintPrice;
    uint256 private _totalSupply;

    mapping(address => uint256) balances;
    mapping(address => mapping(uint256 => address)) allowed;
    mapping (uint256 => address) owners;
    mapping(uint256 => Metadata) metadatas;
    mapping(uint256 => IWeapon) weapons;

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _tokenURI,
        address _ownersContract,
        address _rubiesContract
    ) {
        _totalSupply = 0;
        MintPrice = 0;
        Name = _name;
        Symbol = _symbol;
        TokenURI = _tokenURI;
        OwnersContract = _ownersContract;
        RubiesContract = _rubiesContract;
    }

    function name() external view override returns (string memory _name) {
        _name = Name;
    }

    function symbol() external view override returns (string memory _symbol) {
        _symbol = Symbol;
    }

    function tokenURI() external view override returns (string memory _tokenURI) {
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
        return owners[_tokenId];//return owner
    }

    function allowance(
        uint256 _tokenId
    ) external view override returns (address) {
        return allowed[owners[_tokenId]][_tokenId];
    }

    function safeTransfer(address _to, uint256 _tokenId) 
    external override 
    isValidTokenId(_tokenId)
    isValidAddress(_to)
    isTokenOwner(_tokenId, msg.sender)
    {
        balances[msg.sender] -= metadatas[_tokenId].sellPrice;
        balances[_to] += metadatas[_tokenId].sellPrice;
        
        owners[_tokenId] = _to;

        emit Transfer(msg.sender, _to, _tokenId);
        _checkERC721Receiver(_to, _tokenId);
    }

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external override 
    isValidTokenId(_tokenId)
    isValidAddress(_to)
    isTokenOwner(_tokenId, _from)
    {
        require(msg.sender == owners[_tokenId] || allowed[owners[_tokenId]][_tokenId] == msg.sender, "Not authorized");
        
        balances[msg.sender] -= metadatas[_tokenId].sellPrice;
        balances[_to] += metadatas[_tokenId].sellPrice;
        owners[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);

        _checkERC721Receiver(_to, _tokenId);
    }

    function approve(address _approved, uint256 _tokenId) 
    external override 
    isValidTokenId(_tokenId)
    {
        require(msg.sender == owners[_tokenId] || allowed[owners[_tokenId]][_tokenId] == msg.sender, "Not authorized");
        allowed[msg.sender][_tokenId] = _approved;
        emit Approval(msg.sender, _approved, _tokenId);
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

    function safeMint(string memory _name) external override {
        require(bytes(_name).length > 0, "Invalid _name");
        require(balances[msg.sender] > MintPrice, "Not enough ETH");

        balances[OwnersContract] -= MintPrice;
        _totalSupply++;
        metadatas[_totalSupply] = Metadata(
            _name,
            100,
            50,
            [uint256(0), uint256(0), uint256(0)],
            0,
            0,
            false
        );

        ///ASK
        IRubie(RubiesContract).safeTransferFrom(address(0x0), msg.sender, 1000);
        _checkERC721Receiver(msg.sender, _totalSupply);
    }

    function mintHero(
        uint256 _attackPoints,
        uint256 _armorPoints,
        uint256[3] memory _weapon,
        uint256 _sellPrice,
        uint256 _requiredExperience
    ) external override
    validAttackPoints(_attackPoints)
    validArmorPoints(_armorPoints)
    validSellPrice(_sellPrice)
    validExperience(_requiredExperience)
    {

        _totalSupply++;
        metadatas[_totalSupply] = Metadata(
            "Hero name",
            _attackPoints,
            _armorPoints,
            _weapon,
            _sellPrice,
            _requiredExperience,
            true
        );

        //ASK
        //weapons[_totalSupply] = _weapon;
        owners[_totalSupply] = msg.sender;
        balances[msg.sender] += _sellPrice;
        _checkERC721Receiver(msg.sender, _totalSupply);
    }

    function getSellinformation(
        uint256 _tokenId
    )
        external
        view
        override
        isValidTokenId(_tokenId)
        returns (bool _onSale, uint256 _price, uint256 _requiredExperience)
    {
        _onSale = metadatas[_tokenId].onSale;
        _price = metadatas[_tokenId].sellPrice;
        _requiredExperience = metadatas[_tokenId].requiredExperience;
    }

    function buy(uint256 _tokenId, string memory _newName) 
    external override
    isValidTokenId(_tokenId)
    {
        //ASK
        //require(msg.value >= metadatas[_tokenId].sellPrice, "Not enough ETH");
        
        require(metadatas[_tokenId].onSale, "Character not on sale");
        //ASK
        //talk to experience contract and check if enough

        balances[msg.sender] -= metadatas[_tokenId].sellPrice;
        balances[owners[_tokenId]] += metadatas[_tokenId].sellPrice;
        //metadatas[_tokenId].onSale = false;
        metadatas[_tokenId].name = _newName;

        //ASK
        //talk to weapon contract to change ownership
    }

    function setOnSale(uint256 _tokenId, bool _onSale) external override isValidTokenId(_tokenId) {
        metadatas[_tokenId].onSale = _onSale;
    }

    function currentTokenID()
        external
        view
        override
        returns (uint256 _currentTokenID)
    {
        _currentTokenID = _totalSupply;
    }

    function mintPrice() external view override returns (uint256 _mintPrice) {
        _mintPrice = MintPrice;
    }

    function setMintingPrice(uint256 _mintPrice) external override {
        MintPrice = _mintPrice;
    }

    //ASK
    function collectFee() external override {}

    /// private functions

    function _isSmartContract(address _addr) private view returns (bool) {
        return _addr.code.length > 0;
    }

    function _checkERC721Receiver(address _addr, uint256 _tokenId) private{
        if (false/* TODO _isSmartContract(_addr)*/ ) {
            bytes4 ERC721_TokenReceiver_Hash = 0x150b7a02;
            bytes memory data;
            bytes4 ERC721_Received = IERC721TokenReceiver(_addr).onERC721Received(msg.sender, _addr, _tokenId, data);
            require(ERC721_Received == ERC721_TokenReceiver_Hash, "Invalid contract");
        }
    }

    /// events

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    /// modifiers

    modifier isValidTokenId(uint256 _tokenId) {
        require(_tokenId > 0 && _tokenId <= _totalSupply, "Invalid tokenId");
        _;
    } 

    modifier isValidAddress(address _address) {
        require(_address != address(0), "Invalid address");
        _;
    }

    modifier isTokenOwner(uint256 _tokenId, address _address) {
        require(owners[_tokenId] == _address, "Not the owner");        
        _;
    }

    modifier hasEnoughBalance(uint256 _amount) {
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        _;
    }

    modifier isValidName(string memory _name) {
        require(bytes(_name).length > 0, "Invalid _name");
        _;
    }

    modifier hasEnoughAllowance() {
        require(0 >= MintPrice, "Insufficient allowance");//TODO: fix
        _;
    }

    modifier validAttackPoints(uint256 _attackPoints) {
        require(_attackPoints >= 100, "Invalid _attackPoints");
        _;
    }

    modifier validArmorPoints(uint256 _armorPoints) {
        require(_armorPoints >= 50, "Invalid _armorPoints");
        _;
    }

    modifier validSellPrice(uint256 _sellPrice) {
        require(_sellPrice > 0, "Invalid _sellPrice");
        _;
    }

    modifier validExperience(uint256 _requiredExperience) {
        require(_requiredExperience >= 100, "Invalid _requiredExperience");
        _;
    }
}
