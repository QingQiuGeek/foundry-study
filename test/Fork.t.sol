// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";

contract ForkTest is Test {
    // fork id
    uint256 mainnetFork;
    uint256 optimismFork;

    string MAINNET_RPC_URL = vm.envString("MAINNET_RPC_URL");
    string OPTIMISM_RPC_URL = vm.envString("OPTIMISM_RPC_URL");

    // 每个test函数执行前创建两个不同的分叉
    function setUp() public {
        mainnetFork = vm.createFork(MAINNET_RPC_URL);
        optimismFork = vm.createFork(OPTIMISM_RPC_URL);
    }

    // 校验两个分叉id是否一致
    function testForkIdDiffer() public {
        assert(mainnetFork != optimismFork);
    }

    // 选择一个分叉并验证是否是激活的分叉
    function testCanSelectFork() public {
        vm.selectFork(mainnetFork);
        assertEq(vm.activeFork(), mainnetFork);
    }

    // 选择一个分叉并验证是否是激活的分叉
    function testCanSwitchForks() public {
        vm.selectFork(mainnetFork);
        assertEq(vm.activeFork(), mainnetFork);

        vm.selectFork(optimismFork);
        assertEq(vm.activeFork(), optimismFork);
    }

    function testCanCreateAndSelectForkInOneStep() public {
        // 创建新分叉并选择
        uint256 anotherFork = vm.createSelectFork(MAINNET_RPC_URL);
        assertEq(vm.activeFork(), anotherFork);
    }

    // 给分叉设置块编号
    function testCanSetForkBlockNumber() public {
        vm.selectFork(mainnetFork);
        // 将该 fork 的 block.number 设为 1,337,000
        vm.rollFork(1_337_000);

        assertEq(block.number, 1_337_000);
    }
}
