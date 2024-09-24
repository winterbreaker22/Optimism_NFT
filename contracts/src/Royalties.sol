
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/common/ERC2981.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Royalties is ERC721URIStorage, ERC2981, Ownable {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIdsTracker;
  constructor(string memory _name, string memory _symbol, uint96 _feeNumerator) ERC721(_name, _symbol) {
    _setDefaultRoyalty(msg.sender, _feeNumerator);
  }

  function mintNFT(address recipient, string memory tokenURI) public onlyOwner returns (uint256) {
  _tokenIdsTracker.increment();
  uint256 tokenId = _tokenIdsTracker.current();
  _safeMint(recipient, tokenId);
  _setTokenURI(tokenId, tokenURI);
  return tokenId;
  }

  function mintNFTWithRoyalty(address recipient, string memory tokenURI, address royaltyReceiver, uint96 feeNumerator) public onlyOwner returns (uint256) {
    uint256 tokenId = mintNFT(recipient, tokenURI);
    _setTokenRoyalty(tokenId, royaltyReceiver, feeNumerator);
    return tokenId;
  }

  function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC2981) returns (bool) {
    return super.supportsInterface(interfaceId);
  }

  function _burn(uint256 tokenId) internal virtual override onlyOwner {
    super._burn(tokenId);
    _resetTokenRoyalty(tokenId);
  }

  function burnNFT(uint256 tokenId) public onlyOwner {
    _burn(tokenId);
  }

}
