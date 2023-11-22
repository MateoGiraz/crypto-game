//SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

/// @dev This contract must implement the IWeapon interface
import "../interfaces/IWeapon.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract Weapon is IWeapon {

    string private _name;
    string private _symbol;
    string private _tokenURI;
    uint256 private _totalSupply;
    address private _ownerContract;
    address private _characterContract;
    uint256 private _mintPrice;
    mapping (address => uint256) _balances;
    mapping (uint256 => address) _owners;
    mapping (uint256 => address) _allowances;
    mapping (uint256 => Metadata) _metadatas;

    constructor(string memory _name, string memory _symbol, string memory
    _tokenURI, address _ownerContract, address _characterContract){
        _name = _name;
        _symbol = _symbol;
        _tokenURI = _tokenURI;
        _ownerContract = _ownerContract;
        _characterContract = _characterContract;
        _mintPrice = 0;
    }

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    function _transfer(address _from, address _to, uint256 _tokenId) internal {
        _owners[_tokenId] = _to;
    }

    function name() external view override returns (string memory _name) {
        _name = _name;
    }

    function symbol() external view override returns (string memory _symbol) {
        _symbol = _symbol;
    }

    function tokenURI()
        external
        view
        override
        returns (string memory _tokenURI)
    {
        _tokenURI = _tokenURI;
    }

    function totalSupply() external view override returns (uint256) {
        return _totalSupply;
    }

    /// @notice Return the amount of NFTs each account owns
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

    /// @notice Transfers the ownership of an NFT from sender address to address '_to'
    /// @dev Throw if `_tokenId` is not a valid NFT identifier with "Invalid tokenId".
    /// if so, it calls `onERC721Received` on `_to` and throws if the return value is not 
    /// `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`, message: "Invalid contract".
    function safeTransfer(address _to, uint256 _tokenId) external override {
        require(_tokenId > 0, "Invalid tokenId");
        require(_to != address(0), "Invalid address");
        require(_owners[_tokenId] == msg.sender, "Not the owner");

        if (_to.code.length  > 0) {
            bytes4 onERC721ReceivedSelector = IERC721Receiver(_to).onERC721Received(
                msg.sender,
                address(this),
                _tokenId,
                ""
            );

            require(
                onERC721ReceivedSelector == bytes4(keccak256("onERC721Received(address,address,uint256,bytes)")),
                "Invalid contract"
            );
        }

        _transfer(msg.sender, _to, _tokenId);
        emit Transfer(msg.sender, _to, _tokenId);
    }

    /// @dev When transfer is complete, this function checks if `_to` is a smart contract (code size > 0), 
    /// if so, it calls `onERC721Received` on `_to` and throws if the return value is not 
    /// `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`, message: "Invalid contract".
   function safeTransferFrom(
    address _from,
    address _to,
    uint256 _tokenId
    ) external override {
        require(_tokenId > 0, "Invalid tokenId");
        require(_to != address(0), "Invalid address");
        require(_owners[_tokenId] == _from, "Not the owner");
        require(msg.sender == _from || msg.sender == _allowances[_tokenId], "Not authorized");

        if (_to.code.length  > 0) {
            bytes4 onERC721ReceivedSelector = IERC721Receiver(_to).onERC721Received(
                msg.sender,
                _from,
                _tokenId,
                ""
            );

            require(
                onERC721ReceivedSelector == bytes4(keccak256("onERC721Received(address,address,uint256,bytes)")),
                "Invalid contract"
            );
        }

        _transfer(_from, _to, _tokenId);
        emit Transfer(_from, _to, _tokenId);
    }

    function approve(address _approved, uint256 _tokenId) external override {
        require(_tokenId > 0, "Invalid tokenId");
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
        returns (address _characterContract)
    {
        _characterContract = _characterContract;
    }

    function safeMint(string memory _name) external override {
        require(bytes(_name).length > 0, "Invalid _name");
        require(_balances[msg.sender] >= _mintPrice, "Insufficient balance");
        require(_totalSupply >= _mintPrice, "Insufficient allowance");//TODO: fix

        _totalSupply++;
        _owners[_totalSupply] = msg.sender;
        _metadatas[_totalSupply] = Metadata(
            1,//TODO: fix
            30,
            5,
            _mintPrice,
            _mintPrice,
            _name,
            false
        );

        if (msg.sender.code.length  > 0) {
            bytes4 onERC721ReceivedSelector = IERC721Receiver(msg.sender).onERC721Received(
                msg.sender,
                address(this),
                _totalSupply,
                ""
            );

            require(
                onERC721ReceivedSelector == bytes4(keccak256("onERC721Received(address,address,uint256,bytes)")),
                "Invalid contract"
            );
        }

        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    function mintLegendaryWeapon(
        uint256 _attackPoints,
        uint256 _armorPoints,
        uint256 _sellPrice,
        uint256 _requiredExperience
    ) external override {
        require(_attackPoints > 150, "Invalid _attackPoints");
        require(_armorPoints > 100, "Invalid _armorPoints");
        require(_sellPrice > 0, "Invalid _sellPrice");
        require(_requiredExperience > 10, "Invalid _requiredExperience");
        require(_balances[msg.sender] >= _mintPrice, "Insufficient balance");
        require(_totalSupply >= _mintPrice, "Insufficient allowance");//TODO: fix

        _totalSupply++;
        _owners[_totalSupply] = msg.sender;
        _metadatas[_totalSupply] = Metadata(
            1,//TODO: fix
            _attackPoints,
            _armorPoints,
            _sellPrice,
            _requiredExperience,
            "Lengendary weapon name",
            true
        );

        if (msg.sender.code.length  > 0) {
            bytes4 onERC721ReceivedSelector = IERC721Receiver(msg.sender).onERC721Received(
                msg.sender,
                address(this),
                _totalSupply,
                ""
            );

            require(
                onERC721ReceivedSelector == bytes4(keccak256("onERC721Received(address,address,uint256,bytes)")),
                "Invalid contract"
            );
        }

        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    function getSellInformation(
        uint256 _tokenId
    )
        external
        view
        override
        returns (bool _onSale, uint256 _price, uint256 _requiredExperience)
    {
        //TODO: trow if token not exist
        _onSale = _metadatas[_tokenId].onSale;
        _price = _metadatas[_tokenId].sellPrice;
        _requiredExperience = _metadatas[_tokenId].requiredExperience;
    }

    function buy(uint256 _tokenId, string memory _newName) external override {
        /// @dev The sender must pay the corresponding sellPrice in Rubies, otherwise Throw with "Not enough Rubies"
        
        require(_tokenId > 0, "Invalid tokenId");
        require(_metadatas[_tokenId].onSale, "Weapon not on sale");
        require(_metadatas[_tokenId].requiredExperience <= 0, "Insufficient experience");
        require(_balances[msg.sender] >= _metadatas[_tokenId].sellPrice, "Insufficient balance");
        require(_totalSupply >= _metadatas[_tokenId].sellPrice, "Insufficient allowance");//TODO: fix

        /// @dev If the weapon is equipped to a character, it will be unequipped and then transferred to the new owner.

        _balances[msg.sender] -= _metadatas[_tokenId].sellPrice;
        _balances[_owners[_tokenId]] += _metadatas[_tokenId].sellPrice;
        _owners[_tokenId] = msg.sender;
        _metadatas[_tokenId].onSale = false;
        _metadatas[_tokenId].name = _newName;

    }

    function setOnSale(uint256 _tokenId, bool _onSale) external override {
        require(_tokenId > 0, "Invalid tokenId");
        require(_owners[_tokenId] == msg.sender, "Not the owner");
        _metadatas[_tokenId].onSale = _onSale;
    }

    /// @dev Returns the index of the last token minted
    function currentTokenID()
        external
        view
        override
        returns (uint256 _currentTokenID)
    {
        _currentTokenID = _totalSupply;
    }

    function mintPrice() external view override returns (uint256 _mintPrice) {
        _mintPrice = _mintPrice;
    }

    function setMintPrice(uint256 _mintPrice) external override {
        require(_mintPrice > 0, "Invalid _mintPrice");
        _mintPrice = _mintPrice;
    }

    /// @dev Transfer to the OwnerContract the total balance in ethers that the contract has accumulated as fees.
    /// @dev This method must be able to be called only by ownersContract, otherwise it will Throw with the message "Not owners contract".
    /// @dev In the event that the contract does not have a balance, Throw with the message "zero balance".
    function collectFee() external override {
        require(msg.sender == _ownerContract, "Not owners contract");
        require(address(this).balance > 0, "zero balance");
    }

    function addWeaponToCharacter(
        uint256 _weaponId,
        uint256 _characterId
    ) external override {
        require(_weaponId > 0, "Invalid _weaponId");
        require(_characterId > 0, "Invalid _characterId");
        //require(_metadatas[_characterId].weapons.length < 3, "Weapon slots are full");

        //_metadatas[_characterId].weapons.push(_weaponId);
        _metadatas[_characterId].attackPoints += _metadatas[_weaponId].attackPoints;
        _metadatas[_characterId].armorPonits += _metadatas[_weaponId].armorPonits;
        _metadatas[_characterId].sellPrice += _metadatas[_weaponId].sellPrice;
        _metadatas[_characterId].requiredExperience += _metadatas[_weaponId].requiredExperience;
    }

    function removeWeaponFromCharacter(
        uint256 _weaponId,
        uint256 _characterId
    ) external override {
        require(_weaponId > 0, "Invalid _weaponId");
        require(_characterId > 0, "Invalid _characterId");
        //require(_metadatas[_characterId].weapons.length > 0, "Weapon not equipped");

        //for (uint256 i = 0; i < _metadatas[_characterId].weapons.length; i++) {
        //    if (_metadatas[_characterId].weapons[i] == _weaponId) {
        //        _metadatas[_characterId].weapons[i] = _metadatas[_characterId].weapons[_metadatas[_characterId].weapons.length - 1];
        //        _metadatas[_characterId].weapons.pop();
        //        break;
        //    }
        //}

        _metadatas[_characterId].attackPoints -= _metadatas[_weaponId].attackPoints;
        _metadatas[_characterId].armorPonits -= _metadatas[_weaponId].armorPonits;
        _metadatas[_characterId].sellPrice -= _metadatas[_weaponId].sellPrice;
        _metadatas[_characterId].requiredExperience -= _metadatas[_weaponId].requiredExperience;
    }
}