//SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

/// @dev This contract must implement the ICharacter interface
import "../interfaces/ICharacter.sol";
import "../interfaces/IOwnersContract.sol";
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
    mapping(uint256 => address) owners;
    mapping(uint256 => Metadata) metadatas;
    mapping(address => uint256) owned;

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _tokenURI,
        address _ownersContract
    ) {
        _totalSupply = 0;
        MintPrice = 0;
        Name = _name;
        Symbol = _symbol;
        TokenURI = _tokenURI;
        OwnersContract = _ownersContract;
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
        return owners[_tokenId];
    }

    function ownedBy(
        address owner
    ) external view override returns (uint256) {
        address weaponAddress = IOwnersContract(OwnersContract).addressOf("Weapon");
        require(msg.sender == weaponAddress, "Not called by weapons contract");
        return owned[owner];
    }

    function equip(uint256 _tokenId, uint256 _weaponId) external override {
        address weaponAddress = IOwnersContract(OwnersContract).addressOf("Weapon");
        require(msg.sender == weaponAddress, "Not called by weapons contract");

        for(uint256 i = 0; i < 3; i++) {
            if(metadatas[_tokenId].weapon[i] == uint256(0)) {
                metadatas[_tokenId].weapon[i] = _weaponId;
            }
        }
    }

    function unEquip(uint256 _tokenId, uint256 _weaponId) external override {
        address weaponAddress = IOwnersContract(OwnersContract).addressOf("Weapon");
        require(msg.sender == weaponAddress, "Not called by weapons contract");

        for(uint256 i = 0; i < 3; i++) {
            if(metadatas[_tokenId].weapon[i] == _weaponId) {
                metadatas[_tokenId].weapon[i] = uint256(0);
            }
        }
    }

    function isEquiped(uint256 _tokenId, uint256 _weaponId) external view override returns (bool) {
        address weaponAddress = IOwnersContract(OwnersContract).addressOf("Weapon");
        require(msg.sender == weaponAddress, "Not called by weapons contract");

        for(uint256 i = 0; i < 3; i++) {
            if(metadatas[_tokenId].weapon[i] == _weaponId) {
                return true;
            }
        }
        return false;
    }

    function slotsAreFull(uint256 _tokenId) external view override returns (bool){
        address weaponAddress = IOwnersContract(OwnersContract).addressOf("Weapon");
        require(msg.sender == weaponAddress, "Not called by weapons contract");

        for(uint256 i = 0; i < 3; i++) {
            if(metadatas[_tokenId].weapon[i] == 0) {
                return false;
            }
        }
        return true;
    }

    function increaseStats(uint256 _characterId, uint256 attackPoints, uint256 armorPoints, uint256 sellPrice, uint256 requiredExperience) external override {
        address weaponAddress = IOwnersContract(OwnersContract).addressOf("Weapon");
        require(msg.sender == weaponAddress, "Not called by weapons contract");

        metadatas[_characterId].attackPoints += attackPoints;
        metadatas[_characterId].armorPoints += armorPoints;
        metadatas[_characterId].sellPrice += sellPrice;
        metadatas[_characterId].requiredExperience += requiredExperience;
    }

    function decreaseStats(uint256 _characterId, uint256 attackPoints, uint256 armorPoints, uint256 sellPrice, uint256 requiredExperience) external override {
        address weaponAddress = IOwnersContract(OwnersContract).addressOf("Weapon");
        require(msg.sender == weaponAddress, "Not called by weapons contract");

        metadatas[_characterId].attackPoints -= attackPoints;
        metadatas[_characterId].armorPoints -= armorPoints;
        metadatas[_characterId].sellPrice -= sellPrice;
        metadatas[_characterId].requiredExperience -= requiredExperience;
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
        owned[_to] = _tokenId;

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
        owned[_to] = _tokenId;

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
    ) external view override returns (uint256 _weaponId) {
        uint256 _tokenId = owned[msg.sender];
        Metadata memory metadata = metadatas[_tokenId];

        _weaponId = metadata.weapon[_weaponIndex];
    }

    function safeMint(string memory _name) external override {
        require(bytes(_name).length > 0, "Invalid _name");
        /// @dev Revert if sender not pay the corresponding mintPrice with "Not enough ETH"
        //require(balances[msg.sender] > MintPrice, "Not enough ETH");

        balances[msg.sender] -= MintPrice;
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
        IOwnersContract ownersContract = IOwnersContract(OwnersContract);
        IRubie rubieContract = IRubie(ownersContract.addressOf("Rubie"));
        
        owners[_totalSupply] = msg.sender;
        owned[msg.sender] = _totalSupply;

        /// @dev With each new minted character, the owner account will recieve 1000 RUBIE tokens
        rubieContract.mint(1000, msg.sender);
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

        owners[_totalSupply] = msg.sender;
        owned[msg.sender] = _totalSupply;

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
        
        IOwnersContract ownersContract = IOwnersContract(OwnersContract);
        IRubie rubieContract = IRubie(ownersContract.addressOf("Rubie"));
        require(rubieContract.balanceOf(msg.sender) >= metadatas[_tokenId].requiredExperience, "Insufficient experience");

        IWeapon weaponContract = IWeapon(ownersContract.addressOf("Weapon"));
        for (uint256 i = 0; i < 3; i++) {
            if (metadatas[_tokenId].weapon[i] != 0) {
                weaponContract.safeTransferFrom(address(this), msg.sender, metadatas[_tokenId].weapon[i]);
            }
        }

        balances[msg.sender] -= metadatas[_tokenId].sellPrice;
        balances[owners[_tokenId]] += metadatas[_tokenId].sellPrice;
        metadatas[_tokenId].name = _newName;
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

    function collectFee() external override {
        require(address(this).balance > 0, "zero balance");
        require(msg.sender ==  OwnersContract, "Not owners contract");
        payable(OwnersContract).transfer(address(this).balance);
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