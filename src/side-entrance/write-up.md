### Description

Drain the entire pool

### Root cause

```solidity
function deposit() external payable {
    unchecked {
        balances[msg.sender] += msg.value;
    }
    emit Deposit(msg.sender, msg.value);
}
```

```solidity
function flashLoan(uint256 amount) external {
    uint256 balanceBefore = address(this).balance;

    IFlashLoanEtherReceiver(msg.sender).execute{value: amount}();

    if (address(this).balance < balanceBefore) {
        revert RepayFailed();
    }
}
```

**Cross-function reentrancy**: the validation `address(this).balance < balanceBefore` don't ensure other states keep safe after `flashloan`

### Textual PoC

1. Call `flashLoan(1000 ether)` &rarr; delegate to `execute()`
2. In `execute()` on exploit contract, attacker call `deposit()` with all ETH &rarr; `pool.balance = 1000 ether`, `balances[exploitContract] = 1000 ether`
3. Call `withdraw()` to drain pool &rarr; `pool.balance = 0`, `exploitCotnract.balance = 1000 ether`

### Coded PoC

- [SideEntrance.t.sol](../../test/truster/SideEntrance.t.sol)
- Run
  ```bash
  forge test --mp test/truster/SideEntrance.t.sol
  ```
