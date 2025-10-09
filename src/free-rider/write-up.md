### Description

Steal all NFTs from the marketplace and transfer them to a recovery address

### Root cause

```solidity
function _buyOne(uint256 tokenId) private {
    //...
    _token.safeTransferFrom(_token.ownerOf(tokenId), msg.sender, tokenId);
    payable(_token.ownerOf(tokenId)).sendValue(priceToPay);
    //...
}
```

`ownerOf(tokenId)` change after `safeTransferFrom(...)`, so the payment is sent to buyer instead of the seller

### Textual PoC

1. Use a Uniswap V2 flash swap to borrow WETH (45 WETH) and covert to ETH
2. Attacker have enough balance to `buy(...)` all NFT (without payment) &rarr; steal all NFTs, `attacker.balance = 45ETH`
3. Repay the flash swap with small fee and keep NFTs

### Coded PoC

- [FreeRider.t.sol](../../test/free-rider/FreeRider.t.sol)
- Run
  ```bash
  forge test --mp test/free-rider/FreeRider.t.sol
  ```

### Techniqual note

UniswapV2 support [flash swap](https://docs.uniswap.org/contracts/v2/guides/smart-contract-integration/using-flash-swaps), with small fee anyone can have access to all pool liquidity in 1 transaction
