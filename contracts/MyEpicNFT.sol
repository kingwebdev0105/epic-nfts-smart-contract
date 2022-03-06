// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

// We first import some OpenZeppelin Contracts.
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
// We need some util functions for strings.
import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";
// We need to import the helper functions from the contract that we copy/pasted.
import { Base64 } from "./libraries/Base64.sol";

// We inherit the contract we imported. This means we'll have access
// to the inherited contract's methods.
contract MyEpicNFT is ERC721URIStorage {
    
    mapping (address => uint) private mintedNFTs;

    // Magic given to us by OpenZeppelin to help us keep track of tokenIds.
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // This is our SVG code. All we need to change is the word that's displayed. Everything else stays the same.
    // So, we make a baseSvg variable here that all our NFTs can use.
    string svgPartOne = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='";
    string svgPartTwo = "' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";
    
    // Get fancy with it! Declare a bunch of colors.
    string[] colors = ["red", "#08C2A8", "black", "yellow", "blue", "green"];

    // I create 2 arrays, each with their own theme of random words.
    // Pick some random funny words, names of anime characters, foods you like, whatever! 
    string[] firstWords = ["Kim", "Lee", "Pak", "Choi", "Han", "An", "Chong"];
    string[] secondWords = ["Chol", "Kwang", "Yang", "Chong", "Hun", "Myong", "Gum", "Chang"];

    event newEpicNftMinted(address sender, uint tokenId);

    // We need to pass the name of our NFTs token and it's symbol.
    constructor() ERC721("SquareNFT", "SQUARE") {
        console.log("This is my NFT project. Whoa!");
    }

    function random(string memory seed) internal pure returns(uint) {
        return uint(keccak256(abi.encodePacked(seed)));
    }

    function pickRandomFirstWord(uint tokenId) internal view returns(string memory) {
        uint idx = random(string(abi.encodePacked("FIRST WORD", Strings.toString(tokenId))));
        return firstWords[idx % firstWords.length];
    }

    function pickRandomSecondWord(uint tokenId) internal view returns(string memory) {
        uint idx = random(string(abi.encodePacked("SECOND WORD", Strings.toString(tokenId))));
        return secondWords[idx % secondWords.length];
    }

    function pickRandomColor(uint tokenId) internal view returns(string memory) {
        uint idx = random(string(abi.encodePacked("FILL COLOR", Strings.toString(tokenId))));
        return secondWords[idx % colors.length];
    }

    // A function our user will hit to get their NFT.
    function makeAnEpicNFT() public {

        require(mintedNFTs[msg.sender] < 50, "Up to 50 nfts can be minted!!!");

        // Get the current tokenId, this starts at 0.
        uint256 newItemId = _tokenIds.current();

        // We randomly select the fill color
        string memory color = pickRandomColor(newItemId);

        // We go and randomly grab one word from each of the two arrays.
        string memory first = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory combinedWord = string(abi.encodePacked(first, second));
        
        // I concatenate it all together, and then close the <text> and <svg> tags.
        string memory finalSvg = string(abi.encodePacked(svgPartOne, color, svgPartTwo, first, second, "</text></svg>"));
        console.log("------------------------------");
        console.log(finalSvg);
        console.log("------------------------------");

        // Get all the JSON metadata in place and base64 encode it.
        string memory encodedJson = Base64.encode(
            bytes(
                abi.encodePacked(
                    '{"name": "',
                    combinedWord,
                    '", "description": "A highly acclaimed collection of squares.", '
                    '"image": "data:image/svg+xml;base64,',
                    Base64.encode(bytes(finalSvg)),
                    '"}'
                )
            )
        );
        // Just like before, we prepend data:application/json;base64, to our data.
        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", encodedJson)
        );
        console.log("=====================================");
        console.log(finalTokenUri);
        console.log("=====================================");

        // Actually mint the NFT to the sender using msg.sender.
        _safeMint(msg.sender, newItemId);   
        
        // Set the NFTs data.
        _setTokenURI(newItemId, finalTokenUri);

        console.log("An NFT w/ ID %d has been minted to %s", newItemId, msg.sender);
        emit newEpicNftMinted(msg.sender, newItemId);
        // Increment the counter for when the next NFT is minted.
        _tokenIds.increment();

        mintedNFTs[msg.sender] ++;
    }

    function getTotalNFTsMintedSoFar(address owner) public view returns(uint) {
        return mintedNFTs[owner];
    }
}