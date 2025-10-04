### Description

Drain the entire pool

### Root cause

```solidity
function executeAction(uint256 actionId) external payable returns (bytes memory) {
    if (!_canBeExecuted(actionId)) {
        revert CannotExecute(actionId);
    }

    GovernanceAction storage actionToExecute = _actions[actionId];
    actionToExecute.executedAt = uint64(block.timestamp);

    emit ActionExecuted(actionId, msg.sender);

    return actionToExecute.target.functionCallWithValue(actionToExecute.data, actionToExecute.value);
}
```

The governance system only checks voting at proposal time but doesn't verify it during execution. An attacker can use flash loan to gain enough voting power, propose a malicious action, return the tokens, and execute the proposal after that.

### Textual PoC

1. Call `flashloan(...)` &rarr; attacker get enough vote right
2. Propose `queueAction(...)` and return flash loan &rarr; create a malicious proposal
3. Wait 2 days and execute proposal &rarr; call `emergencyExit`, transfer all token to attacker

### Coded PoC

- [Selfie.t.sol](../../test/selfie/Selfie.t.sol)
- Run
  ```bash
  forge test --mp test/selfie/Selfie.t.sol
  ```
