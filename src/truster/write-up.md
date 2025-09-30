### Description

Drain the pool in only 1 transaction

### Root cause

```solidity
function flashLoan(uint256 amount, address borrower, address target, bytes calldata data) external nonReentrant returns (bool)
{
    //...
    target.functionCall(data);
    //...
}
```

**Unexpected call**: allow anyone to specify `target`, `data` to execute arbitrary external call

### Textual PoC

1. Call `flashLoan(..., target, data)` with:

- `target = token`
- `data = abi.encodeWithSelector(token.approve.selector, attacker, poolBalance)`

  &rarr; pool `approve` attacker contract

2. attacker contract can `transferFrom` to recover <br>

### Coded PoC

- [Truster.t.sol](../../test/truster/Truster.t.sol)
- Run
  ```bash
  forge test --mp test/truster/Truster.t.sol --isolate
  ```
