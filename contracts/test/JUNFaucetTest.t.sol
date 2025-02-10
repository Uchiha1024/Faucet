// SPDX-License-Identifier: MIT
// 许可证声明：指定合约的版权许可为 MIT，允许代码的自由使用和修改。

pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {JunCoin} from "../src/JunCoin.sol";
import {JUNFaucet} from "../src/JUNFaucet.sol";

contract JUNFaucetTest is Test {
    // 定义一个公共的 LuLuCoin 类型的变量 llc，用于测试中的代币合约实例。
    JunCoin public jun;
    // 定义一个公共的 LLCFaucet 类型的变量 faucet，用于测试中的水龙头合约实例。
    JUNFaucet public junFaucet;

    // 定义一个变量 owner，表示合约所有者的地址。
    address owner = vm.addr(1);
    // 定义一个变量 user，表示用户的地址。
    address user = vm.addr(2);
    // 定义一个领取间隔为 10 秒，用于控制用户请求代币的最小间隔时间。
    uint256 dripInterval = 10 seconds;
    // 定义一个领取限制为 100 代币，用于控制用户请求代币的最大数量。
    uint256 dripLimit = 100;

    function setUp() public {
        // 创建一个新的 LuLuCoin 合约实例，指定合约所有者。
        jun = new JunCoin(owner);
        // 创建一个新的 LLCFaucet 合约实例，指定代币合约地址、领取间隔、领取限制和合约所有者。
        junFaucet = new JUNFaucet(address(jun), dripInterval, dripLimit, owner);
        // 给合约所有者分配 1,000 个以太币。
        vm.deal(owner, 1_1000 ether);
        // 给用户分配 1000 个以太币。
        vm.deal(user, 1000 ether);
        // 模拟合约所有者
        vm.prank(owner);
        // 铸造代币
        jun.mint(1_000);
    }

    modifier ownerDeposit(){
        vm.startPrank(owner);
        // 授权水龙头
        jun.approve(address(junFaucet), 1_000);
        // 存入代币
        junFaucet.deposit(1_000);
        vm.stopPrank();
          // 模拟时间流逝，确保时间超过领取间隔。
        vm.warp(block.timestamp + dripInterval + 1);

        _;
    }

    // 定义测试函数 testSuccessIfOwnerSetDripLimit，测试合约所有者是否能成功设置领取限制。
    function testSuccessIfOwnerSetDripLimit() public {
        uint256 newDripLimit = 200;
        // 模拟合约所有者的操作。
        vm.startPrank(owner);
        // 设置领取限制
        junFaucet.setDripLimit(newDripLimit);
        // 停止模拟合约所有者的操作。
        vm.stopPrank();
        // 验证领取限制是否设置成功
        assertEq(junFaucet.getDripLimit(), newDripLimit);
    }

    // 定义测试函数 testSuccessIfOwnerSetDripInterval，测试合约所有者是否能成功设置领取间隔。
    function testSuccessIfOwnerSetDripInterval() public {
        uint256 newDripInterval = 20 seconds;
        vm.startPrank(owner);
        junFaucet.setDripInterval(newDripInterval);
        vm.stopPrank();
        assertEq(junFaucet.getDripInterval(), newDripInterval);
    }
    // 定义测试函数 testSuccessIfOwnerSetTokenAddress，测试合约所有者是否能成功设置代币地址。
    function testSuccessIfOwnerSetTokenAddress() public {
        address newTokenAddress = vm.addr(3);
        vm.startPrank(owner);
        junFaucet.setTokenAddress(newTokenAddress);
        vm.stopPrank();
        assertEq(junFaucet.tokenAddress(), newTokenAddress);
    }
    // 定义测试函数 testSuccessIfOwnerDeposit，测试合约所有者是否能成功存入代币。
    function testSuccessIfOwnerDeposit() public {
        vm.startPrank(owner);
        // 授权水龙头
        jun.approve(address(junFaucet), 1_000);
        // 存入代币
        junFaucet.deposit(1_000);
        vm.stopPrank();
        assertEq(jun.balanceOf(address(junFaucet)), 1_000);
    }

     // 定义测试函数 testSuccessIfUserDrip，测试用户是否能成功领取代币。
     function testSuccessIfUserDrip() public ownerDeposit{
        vm.startPrank(user);
        // 领取代币
        junFaucet.drip(10);
        vm.stopPrank();
        assertEq(jun.balanceOf(user), 10);

     }
       // 定义测试函数 testRevertIfTimeHasNotPassed，测试如果时间未过，则应 revert。
    function testRevertIfTimeHasNotPassed() public {
        vm.startPrank(owner);
        // 授权水龙头
        jun.approve(address(junFaucet), 1_000);
        // 存入代币
        junFaucet.deposit(1_000);
        vm.stopPrank();
        vm.startPrank(user);
        vm.expectRevert();
        junFaucet.drip(10);
    }
    // 定义测试函数 testRevertIfAmountLimit，测试如果请求的代币数量超过限制应 revert。
    function testRevertIfAmountLimit() public ownerDeposit{
        vm.startPrank(user);
        vm.expectRevert();
        junFaucet.drip(101);
    }

     // 定义测试函数 testRevertIfFaucetEmpty，测试如果水龙头代币不足应 revert。
     function testRevertIfFaucetEmpty() public ownerDeposit{
        vm.startPrank(owner);
        // 调整限额
        junFaucet.setDripLimit(2000);
        vm.stopPrank();

        vm.startPrank(user);
        junFaucet.drip(1000);
        assertEq(jun.balanceOf(user), 1000);
        assertEq(jun.balanceOf(address(junFaucet)), 0);
        vm.warp(block.timestamp + dripInterval);
        // 模拟时间流逝，确保时间超过领取间隔。
        vm.expectRevert();
        // 用户再次请求领取 1 个代币，但水龙头已空，应 revert。
        junFaucet.drip(10);
     
     }


}
