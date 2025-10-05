### Description

Transfer all token in pool to recovery address

### Root cause

```solidity
function calculateDepositRequired(uint256 amount) public view returns (uint256) {
    return amount * _computeOraclePrice() * DEPOSIT_FACTOR / 10 ** 18;
}

function _computeOraclePrice() private view returns (uint256) {
    return uniswapPair.balance * (10 ** 18) / token.balanceOf(uniswapPair);
}
```

The pool use Uniswap v1's spot price as an oracle. Attacker can dumping large amounts of token into Uniswap, artificially lowering the token price

### Textual PoC

1. `tokenToEthSwapInput(...)` &rarr; decrease the ETH price
2. `borrow(...)` &rarr; borrow entire pool with low ETH collateral price
   - If the token amount's large enough, the collateral become very small

### Coded PoC

- [Puppet.t.sol](../../test/puppet/Puppet.t.sol)
- Run
  ```bash
  forge test --mp test/puppet/Puppet.t.sol --isolate
  ```
- **Note**: This code attack with 2 transactions, while the requirement is only use 1

### Real world attacks

- [bZx](https://www.palkeo.com/en/projets/ethereum/bzx.html)
- [PancakeBunny](https://watchpug.medium.com/the-pancakebunny-bunny-pool-incident-analysis-71fb67c1536e)
