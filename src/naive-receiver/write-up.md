### Description

Recover all funds from both pool and receiver by transferring them to the recovery address

### Root cause

```solidity
function _msgSender() internal view override returns (address) {
    if (msg.sender == trustedForwarder && msg.data.length >= 20) {
        return address(bytes20(msg.data[msg.data.length - 20:]));
    }
    //...
}
```

```solidity
function multicall(bytes[] calldata data) external virtual returns (bytes[] memory results) {
    results = new bytes[](data.length);
    for (uint256 i = 0; i < data.length; i++) {
        results[i] = Address.functionDelegateCall(address(this), data[i]);
    }
    return results;
}
```

The contract assumes calls from the forwarder always have the sender’s address at the end of `msg.data`. However, `multicall(...)` uses `delegatecall(address(this), data)`, which can change `msg.data` and break this assumption, allowing sender spoofing.

### Textual PoC

1. Call `flashLoan(receiver,...)` 10 times to drain receiver balance &rarr; `deposit[deployer] = 1010e18`
2. Create and sign request (`multicall`) offchain
3. Forward request &rarr; `multicall([withdraw(all, recover)])` &rarr; delegate to `withdraw(all, recover)` &rarr; `balance[recover] = 1010`, `balance[pool] = 0`

### Coded PoC

- [NaiveReceiver.t.sol](../../test/naive-receiver/NaiveReceiver.t.sol)
- Run
  ```bash
  forge test --mp test/naive-receiver/NaiveReceiver.t.sol
  ```
