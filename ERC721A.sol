// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "erc721a/contracts/ERC721A.sol";

contract Azuki is ERC721A {

    address public owner;
    address[] addressOfReserved;
    uint16 public countReserved = 0;
    address[] corporateAddresses;

    constructor() ERC721A("Spacebear", "SBR") {
        owner = msg.sender;
    }

    function mint(address to) external payable {
        // `_mint`'s second argument now takes in a `quantity`, not a `tokenId`.
        uint256 MaxSupply = 90;
        

        if (countReserved<10 && isReserved(to)) {

            require(msg.value == 1 ether, "Insufficient funds. funds must be greater than 1");

            require(!addressOwnsNFT(to), "one token one address");
            
            _mint(to, 1);

            countReserved++;
        }else{
            require(msg.value == 1 ether, "Insufficient funds. funds must be greater than 1");

            require(totalSupply() < MaxSupply, "Exceeded amount of NFT's mintable.");

            require(!addressOwnsNFT(to), "one token one address");

            _mint(to, 1);
        }
    
    }


    function isReserved(address _address) public view returns (bool) {
        for (uint256 i = 0; i < addressOfReserved.length; i++) {
            if (addressOfReserved[i] == _address) {
                return true;
            }
        }
        return false;
    }

    function isCorporateAddress(address user) public view returns (bool) {
        for (uint256 i = 0; i < corporateAddresses.length; i++) {
            if (corporateAddresses[i] == user) {
                return true;
            }
        }
        return false;
    }

    function mintCorporate(address to) external payable {
        // `_mint`'s second argument now takes in a `quantity`, not a `tokenId`.
        uint256 MaxSupply = 5;

        require(isCorporateAddress(to), "Only corporate can mint corporate NFTs.");

        require(msg.value == 5 ether, "Insufficient funds. funds must be greater than 5");
        
        require(totalSupply()< MaxSupply, "Value must be greater than zero");

        require(!addressOwnsNFT(to), "one token one address");

        _mint(owner, 1);
        
    }



     function addressOwnsNFT(address user) public view returns (bool) {
        uint256 balance = balanceOf(user);
        return balance > 0;
    }

    function _baseURI() internal pure override returns (string memory) {
        return 'https://white-wrong-kangaroo-454.mypinata.cloud/ipfs/QmWabUE8z3p4U7yZ7y2LpPgLHhCrCdWvsxe3C5ssUGyPtX/';
    }

    function addReservedAddress(address user) public {
        require(msg.sender == owner, "You do not have rights to add address");
        addressOfReserved.push(user);
    }

    function addCorporateAddress(address to) external  {
        require(msg.sender == owner, "Only address owner can grant access.");
        corporateAddresses.push(to);
    }


}