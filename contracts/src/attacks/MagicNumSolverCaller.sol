// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract MagicNumSolverCaller {
    function doCall(address _target) external returns (uint256 res) {
        // Encode the function selector for the target call
        (bool success, bytes memory result) = _target.call(abi.encodeWithSignature("whatIsTheMeaningOfLife()"));

        // Check if the call was successful
        require(success, "Call to target contract failed");
        res = uint256(abi.decode(result, (bytes32)));
    }
}
