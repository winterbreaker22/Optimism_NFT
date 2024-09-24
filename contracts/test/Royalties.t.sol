
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Royalties.sol";

contract RoyaltiesTest is Test {
  Royalties private royalties;
  address private owner;
  uint96 private defaultFeeNumerator = 100;
  string private symbol = "ROYAL";
  string private name = "Royalties";
  address private alice = makeAddr("alice");
  address private bob = makeAddr("bob");

  function setUp() public {
    owner = address(this);
    royalties = new Royalties(name, symbol, defaultFeeNumerator);
  }

  function testInitialState public {
    assertEq(royalties.name(), name, "The name should be Royalties");
    assertEq(royalties.symbol(), symbol, "The symbol should be ROYAL");
  }

  function testSupportsERC721Interface() public {
    assertEq(royalties.supportsInterface(0x80ac58cd), true);
  }

  function testSupportsERC2981Interface() public {
    assertEq(royalties.supportsInterface(0x2a55205a), true);
  }

  function testMintNFT() public {
    uint256 tokenId = royalties.mintNFT(alice, "tokenURI");
    assertEq(royalties.ownerOf(tokenId), alice);
    assertEq(royalties.tokenURI(tokenId), "tokenURI");
  }

  function testReturnsRoyaltyInfo() public {
    uint256 tokenId = royalties.mintNFTWithRoyalty(alice, "tokenURI", bob, 1000);
    (address receiver, uint256 amount) = royalties.royaltyInfo(tokenId, 500);
    assertEq(receiver, bob);
    assertEq(amount, 50);
  }

}
