// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface NFTOwner {
    function ownerOf(uint16 index) external view returns (address);
}

contract NFTFunctions {
    address public owner;
    address public nftOwnerContractAddress;
    string[] public punkAttributesList;
    bytes[] public punkImageBytes;
    uint16 public totalPunks;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    modifier onlyPunkOwner(uint16 index) {
        require(NFTOwner(nftOwnerContractAddress).ownerOf(index) == msg.sender, "Only owner");
        _;
    }

    modifier unsealed() {
        // Add your unsealed modifier logic here
        _;
    }

    constructor(address _nftOwnerContractAddress, uint16 _totalPunks) {
        owner = msg.sender;
        nftOwnerContractAddress = _nftOwnerContractAddress;
        totalPunks = _totalPunks;
    }

    function setNFTOwnerContract(address _nftOwnerContractAddress) external onlyOwner {
        nftOwnerContractAddress = _nftOwnerContractAddress;
    }

    function addPunk(uint16 index, bytes memory _data)
        external
        onlyPunkOwner(index)
        unsealed
    {
        require(index < totalPunks, "Index out of range");
        if (index >= punkImageBytes.length) {
            uint256 elementsToAdd = (index - punkImageBytes.length) + 1;
            for (uint256 i = 0; i < elementsToAdd; i++) {
                punkImageBytes.push("");
            }
        }
        punkImageBytes[index] = _data;
    }

    function addPunkAttributesList(string[] memory input)
        external
        onlyOwner
        unsealed
    {
        for (uint256 i = 0; i < input.length; i++) {
            punkAttributesList.push(input[i]);
        }
    }
}
