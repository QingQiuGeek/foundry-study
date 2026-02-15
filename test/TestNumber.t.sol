pragma solidity ^0.8.10;

import {Test} from "forge-std/Test.sol";

contract ContractBTest is Test {
    uint256 testNumber;

    // setUp()是测试生命周期的钩子，会在每个测试用例执行前调用一次，不是构造函数！
    function setUp() public {
        testNumber = 42;
    }

    // foundry约定，要测试的函数，前缀要加上test，否则forge test不会执行这个函数！
    function test_NumberIs42() public {
        assertEq(testNumber, 42);
    }

    function testSubtract43() public {
        // // testNumber是无符号整数，执行之后-1报错:arithmetic underflow or overflow (0x11)
        testNumber -= 43;
    }
}

// testC 被配置为使用由 testA 和 setB(uint256) 函数修改的状态
contract ContractTest is Test {
    uint256 a;
    uint256 b;

    function beforeTestSetup(bytes4 testSelector) public pure returns (bytes[] memory beforeTestCalldata) {
        if (testSelector == this.testC.selector) {
            beforeTestCalldata = new bytes[](2);
            beforeTestCalldata[0] = abi.encodePacked(this.testA.selector);
            beforeTestCalldata[1] = abi.encodeWithSignature("setB(uint256)", 1);
        }
    }

    function testA() public {
        require(a == 0);
        a += 1;
    }

    function setB(uint256 value) public {
        b = value;
    }

    function testC() public {
        assertEq(a, 1);
        assertEq(b, 1);
    }
}

