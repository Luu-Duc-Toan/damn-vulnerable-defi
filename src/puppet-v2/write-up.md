### Description

Transfer all token in pool to recovery address

### Root cause

```solidity
function quote(uint256 amountA, uint256 reserveA, uint256 reserveB) internal pure returns (uint256 amountB) {
    require(amountA > 0, "UniswapV2Library: INSUFFICIENT_AMOUNT");
    require(reserveA > 0 && reserveB > 0, "UniswapV2Library: INSUFFICIENT_LIQUIDITY");
    amountB = amountA * reserveB / reserveA;
}
```

Uniswap v2 provides a secure on-chain price oracle using time-weighted average price (TWAP). However, the pool incorrectly uses Uniswap v2 by relying only on the current reserves (`reserve0`, `reserve1`) instead of calculating the average price $P_\text{avg} = \frac{priceCumulative_t - priceCumulative_{t_0}}{t - t_0}$. This mistake makes the using of Uniswap v2 have no difference from Uniswap v1, and allows the same exploit as in [puppet](../puppet/README.md).

### Textual PoC

1. `swapExactTokensForETHSupportingFeeOnTransferTokens(...)` &rarr; decrease the WETH price
2. Deposit ETH to `WETH`
3. `borrow(...)` &rarr; borrow entire pool with low WETH collateral price
   - If the token amount's large enough, the collateral become very small

### Coded PoC

- [PuppetV2.t.sol](../../test/puppet-v2/PuppetV2.t.sol)
- Run
  ```bash
  forge test --mp test/puppet-v2/PuppetV2.t.sol --isolate
  ```
