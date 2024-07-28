// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "erc721a/contracts/ERC721A.sol";

contract Azuki is ERC721A {

    address public owner;
    address[] addressOfReserved;
    uint16 public countReserved = 0;

    constructor() ERC721A("Spacebear", "SBR") {
        owner = msg.sender;
    }

    function mint(address to) external payable {
        // `_mint`'s second argument now takes in a `quantity`, not a `tokenId`.
        uint256 MaxSupply = 85;
        

        if (countReserved<10 && isAddressInList(to)) {

            require(!addressOwnsNFT(to), "one token one address");
            
            _mint(to, 1);
        }else{
            require(msg.value > 1 ether, "Insufficient funds. funds must be greater than 1");

            require(totalSupply() < MaxSupply, "Value must be greater than zero");

            require(!addressOwnsNFT(to), "one token one address");

            _mint(to, 1);
        }
    
    }
    function isAddressInList(address _address) public view returns (bool) {
        for (uint256 i = 0; i < addressOfReserved.length; i++) {
            if (addressOfReserved[i] == _address) {
                return true;
            }
        }
        return false;
    }

    function mintCorporate(address to) external payable {
        // `_mint`'s second argument now takes in a `quantity`, not a `tokenId`.
        uint256 MaxSupply = 5;

        require(msg.value > 5 ether, "Insufficient funds. funds must be greater than 5");
        
        require(totalSupply()< MaxSupply, "Value must be greater than zero");

        require(!addressOwnsNFT(to), "one token one address");

        require(owner == to , "Only one token per address");
        _mint(owner, 1);
    }

     function addressOwnsNFT(address user) public view returns (bool) {
        uint256 balance = balanceOf(user);
        return balance > 0;
    }

    function _baseURI() internal pure override returns (string memory) {
        return 'https://ethereum-blockchain-developer.com/2022-06-nft-truffle-hardhat-foundry/nftdata/';
    }

    function addReservedAddress(address user) public {
        require(address(this) == owner, "You do not have rights to add address");
        addressOfReserved.push(user);
    }

}
