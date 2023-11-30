//SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

/// @dev This contract must implement the IWeapon interface
import "../interfaces/IOwnersContract.sol";
import "../interfaces/IRubie.sol";
import "../interfaces/IWeapon.sol";
import "../interfaces/IERC721TokenReceiver.sol";
import "../interfaces/ICharacter.sol";

contract Weapon is IWeapon {

    string  _name;
    string  _symbol;
    string  _tokenURI;
    uint256  _totalSupply;
    address  _ownerContract;
    address  _characterContract;
    uint256  _mintPrice;
    mapping (address => uint256) _balances;
    mapping (uint256 => address) _owners;
    mapping (uint256 => address) _allowances;
    mapping (uint256 => Metadata) _metadatas;

    constructor(string memory name, string memory symbol, string memory
    tokenURI, address ownerContract, address characterContract) isValidName(name){
        require(bytes(symbol).length == 3, "Invalid Symbol");
        _name = name;
        _symbol = symbol;
        _tokenURI = tokenURI;
        _ownerContract = ownerContract;
        _characterContract = characterContract;
        _mintPrice = 1;
    }

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    function _transfer(address _from, address _to, uint256 _tokenId) internal {
        _owners[_tokenId] = _to;
    }

    function name() external view override returns (string memory name) {
        name = _name;
    }

    function symbol() external view override returns (string memory symbol) {
        symbol = _symbol;
    }

    function tokenURI()
        external
        view
        override
        returns (string memory tokenURI)
    {
        tokenURI = _tokenURI;
    }

    function totalSupply() external view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(
        address _owner
    ) external view override returns (uint256) {
        return _balances[_owner];
    }

    function ownerOf(
        uint256 _tokenId
    ) external view override returns (address) {
        return _owners[_tokenId];
    }

    function allowance(
        uint256 _tokenId
    ) external view override returns (address) {
        return _allowances[_tokenId];
    }

    function safeTransfer(address _to, uint256 _tokenId) external override 
    isValidTokenId(_tokenId) 
    isValidAddress(_to)
    isTokenOwner(_tokenId, msg.sender)
    {
        _transfer(msg.sender, _to, _tokenId);
        _balances[msg.sender]--;
        _balances[_to]++;
        emit Transfer(msg.sender, _to, _tokenId);
        _checkERC721Receiver(_to, _tokenId);
    }

   function safeTransferFrom(address _from,address _to, uint256 _tokenId) external override 
    isValidTokenId(_tokenId) 
    isValidAddress(_to)
    isTokenOwner(_tokenId, _from)
    {
        require(msg.sender == _from || msg.sender == _allowances[_tokenId], "Not authorized");
        
        _transfer(_from, _to, _tokenId);
        _balances[_from]--;
        _balances[_to]++;
        emit Transfer(_from, _to, _tokenId);
        _checkERC721Receiver(_to, _tokenId);
    }

    function approve(address _approved, uint256 _tokenId) external override isValidTokenId(_tokenId) {
        require(_owners[_tokenId] == msg.sender || msg.sender == _allowances[_tokenId], "Not authorized");
        
        _allowances[_tokenId] = _approved;
        emit Approval(msg.sender, _approved, _tokenId);
    }

    function metadataOf(
        uint256 _tokenId
    ) external view override returns (Metadata memory _metadata) {
        _metadata = _metadatas[_tokenId];
    }

    function characterContract()
        external
        view
        override
        returns (address characterContract)
    {
        characterContract = _characterContract;
    }

    function safeMint(string memory name) external override 
    isValidName(name)
    hasEnoughBalance(_mintPrice)
    ///hasEnoughAllowance()
    {
        _totalSupply++;
        _owners[_totalSupply] = msg.sender;
        _metadatas[_totalSupply] = Metadata(
            0,
            30,
            5,
            _mintPrice,
            _mintPrice,
            name,
            false
        );

        _owners[_totalSupply] = msg.sender;
        
        _balances[msg.sender]++;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    function mintLegendaryWeapon(
        uint256 _attackPoints,
        uint256 _armorPoints,
        uint256 _sellPrice,
        uint256 _requiredExperience
    ) external override
    validAttackPoints(_attackPoints)
    validArmorPoints(_armorPoints)
    validSellPrice(_sellPrice)
    validRequiredExperience(_requiredExperience) 
    hasEnoughBalance(_mintPrice) 
    ///hasEnoughAllowance() 
    {
        _totalSupply++;
        _owners[_totalSupply] = msg.sender;
        _metadatas[_totalSupply] = Metadata(
            0,
            _attackPoints,
            _armorPoints,
            _sellPrice,
            _requiredExperience,
            "Lengendary weapon name",
            true
        );
        _balances[msg.sender]++;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    function getSellInformation(uint256 _tokenId) 
    external view override 
    isValidTokenId(_tokenId)
    returns (bool _onSale, uint256 _price, uint256 _requiredExperience)
    {
        _onSale = _metadatas[_tokenId].onSale;
        _price = _metadatas[_tokenId].sellPrice;
        _requiredExperience = _metadatas[_tokenId].requiredExperience;
    }

    function buy(uint256 _tokenId, string memory _newName) external override isValidTokenId(_tokenId) {
        IOwnersContract ownersContract = IOwnersContract(_ownerContract);
        IRubie rubieContract = IRubie(ownersContract.addressOf("Rubie"));

        require(rubieContract.balanceOf(msg.sender) > _metadatas[_tokenId].sellPrice, "Not enough Rubies");

        require(_metadatas[_tokenId].onSale, "Weapon not on sale");
        require(_metadatas[_tokenId].requiredExperience <= 0, "Insufficient experience");
        require(_balances[msg.sender] >= _metadatas[_tokenId].sellPrice, "Insufficient balance");
        //require(_totalSupply >= _metadatas[_tokenId].sellPrice, "Insufficient allowance");//TODO: fix

        ICharacter charactersContract = ICharacter(ownersContract.addressOf("Character"));
        uint256 characterToken = charactersContract.ownedBy(msg.sender);
        charactersContract.unEquip(characterToken, _tokenId);

        rubieContract.safeTransferFrom(msg.sender, _owners[_tokenId], _metadatas[_tokenId].sellPrice);

        _balances[msg.sender] --;
        _balances[_owners[_tokenId]] ++;
        _owners[_tokenId] = msg.sender;
        _metadatas[_tokenId].onSale = false;
        _metadatas[_tokenId].name = _newName;

        emit Transfer(_owners[_tokenId], msg.sender, _tokenId);
    }

    function setOnSale(uint256 _tokenId, bool _onSale) external override isValidTokenId(_tokenId) {
        require(_owners[_tokenId] == msg.sender, "Not the owner");
        _metadatas[_tokenId].onSale = _onSale;
    }

    function currentTokenID()
        external
        view
        override
        returns (uint256 _currentTokenID)
    {
        _currentTokenID = _totalSupply;
    }

    function mintPrice() external view override returns (uint256 mintPrice) {
        mintPrice = _mintPrice;
    }

    function setMintPrice(uint256 mintPrice) external override {
        require(mintPrice > 0, "Invalid _mintPrice");
        _mintPrice = mintPrice;
    }

    function collectFee() external override {
        require(msg.sender == _ownerContract, "Not owners contract");
        require(address(this).balance > 0, "zero balance");
        
        payable(_ownerContract).transfer(address(this).balance);
    }

    function addWeaponToCharacter(
        uint256 _weaponId,
        uint256 _characterId
    ) external override {
        ICharacter characterContract = ICharacter(_characterContract);
        require(_weaponId > 0 && _weaponId <= _totalSupply, "Invalid _weaponId");
        require(_characterId > 0 && _characterId <= characterContract.totalSupply(), "Invalid _characterId");
        require(!characterContract.isEquiped(_characterId, _weaponId), "Weapon already equipped");
        require(!characterContract.slotsAreFull(_characterId), "Weapon slots are full");
        
        uint256 attackPoints = _metadatas[_weaponId].attackPoints;
        uint256 armorPoints = _metadatas[_weaponId].armorPoints;
        uint256 sellPrice = _metadatas[_weaponId].sellPrice;
        uint256 requiredExperience = _metadatas[_weaponId].requiredExperience;

        characterContract.increaseStats(_characterId, attackPoints, armorPoints, sellPrice, requiredExperience);
        characterContract.equip(_characterId, _weaponId);
    }

    function removeWeaponFromCharacter(
        uint256 _weaponId,
        uint256 _characterId
    ) external override {
        ICharacter characterContract = ICharacter(_characterContract);
        require(_weaponId > 0 && _weaponId <= _totalSupply, "Invalid _weaponId");
        require(_characterId > 0 && _characterId <= characterContract.totalSupply(), "Invalid _characterId");
        require(characterContract.isEquiped(_characterId, _weaponId), "Weapon not equipped");
        
        uint256 attackPoints = _metadatas[_weaponId].attackPoints;
        uint256 armorPoints = _metadatas[_weaponId].armorPoints;
        uint256 sellPrice = _metadatas[_weaponId].sellPrice;
        uint256 requiredExperience = _metadatas[_weaponId].requiredExperience;

        characterContract.decreaseStats(_characterId, attackPoints, armorPoints, sellPrice, requiredExperience);
        characterContract.unEquip(_characterId, _weaponId);
    }

    function setOwnership(uint256 _characterId, address newOwner) external override {
        address charactersContract = IOwnersContract(_ownerContract).addressOf("Character");
        require(msg.sender ==  charactersContract, "Not called by characters contract");
        _owners[_characterId] = newOwner;
    }

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
        require(_owners[_tokenId] == _address, "Not the owner");        
        _;
    }

    modifier hasEnoughBalance(uint256 _amount) {
        IOwnersContract ownersContract = IOwnersContract(_ownerContract);
        IRubie rubieContract = IRubie(ownersContract.addressOf("Rubie"));
        require(rubieContract.balanceOf(msg.sender) >= _amount, "Not enough ETH");
        _;
    }

    modifier isValidName(string memory name) {
        require(bytes(name).length > 0, "Invalid _name");
        _;
    }

    modifier hasEnoughAllowance() {
        IOwnersContract ownersContract = IOwnersContract(_ownerContract);
        IRubie rubieContract = IRubie(ownersContract.addressOf("Rubie"));
        require(rubieContract.allowance(msg.sender, address(this)) >= _mintPrice, "Not enough allowance");
        _;
    }

        modifier validAttackPoints(uint256 _attackPoints) {
        require(_attackPoints > 150, "Invalid _attackPoints");
        _;
    }

    modifier validArmorPoints(uint256 _armorPoints) {
        require(_armorPoints > 100, "Invalid _armorPoints");
        _;
    }

    modifier validSellPrice(uint256 _sellPrice) {
        require(_sellPrice > 0, "Invalid _sellPrice");
        _;
    }

    modifier validRequiredExperience(uint256 _requiredExperience) {
        require(_requiredExperience > 10, "Invalid _requiredExperience");
        _;
    }
}

