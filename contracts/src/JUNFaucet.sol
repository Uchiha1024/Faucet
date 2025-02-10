// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract JUNFaucet is Ownable {
    using SafeERC20 for IERC20;
    // 定义一个 IERC20 类型的变量 token，用于存储要发放的代币合约
    IERC20 public immutable token;
    // 定义一个地址类型的变量 tokenAddress，用于存储代币合约的地址。
    address public tokenAddress;

    // 定义一个 uint256 类型的变量 dripInterval，用于设置用户请求代币的最小间隔时间。
    uint256 public dripInterval;
    // 定义一个 uint256 类型的变量 dripLimit，用于设置用户每次最多可以领取的代币数量。
    uint256 public dripLimit;

    // 定义一个 mapping 类型的变量 dripTimes，用于记录用户上次领取代币的时间。
    mapping(address => uint256) public dripTimes;

    // 定义一个错误类型，当用户请求代币的间隔时间未过时抛出此错误。
    error JUNFaucet__IntervalHasNotPassed();
    // 定义一个错误类型，当用户请求领取的代币数量超过最大限制时抛出此错误。
    error JUNFaucet__ExceedLimit();
    // 定义一个错误类型，当水龙头中没有足够代币时抛出此错误。
    error JUNFaucet__FaucetNotEnough();
    // 定义一个错误类型，当存入的代币数量无效时抛出此错误。
    error JUNFaucet__InvalidAmount();

    // 定义一个事件，当用户成功领取代币时触发，记录接收者地址和领取的代币数量。
    event JUNFaucet__Drip(address indexed Receiver, uint256 indexed Amount);
    // 定义一个事件，当合约所有者存入代币时触发，记录存入的代币数量。
    event JUNFaucet__OwnerDeposit(uint256 indexed amount);

    constructor(
        address _tokenAddress,
        uint256 _dripInterval,
        uint256 _dripLimit,
        address _owner
    ) Ownable(_owner) {
        token = IERC20(_tokenAddress);
        dripInterval = _dripInterval;
        dripLimit = _dripLimit;
        tokenAddress = _tokenAddress;
    }

    // 定义一个函数 drip，用于用户领取代币。
    function drip(uint256 _amount) external {
        // 设置目标领取代币数量
        uint256 targetAmount = _amount;
        //校验时间
        if (block.timestamp - dripTimes[msg.sender] < dripInterval) {
            revert JUNFaucet__IntervalHasNotPassed();
        }
        // 校验领取数量
        if (targetAmount > dripLimit) {
            revert JUNFaucet__ExceedLimit();
        }
        // 校验水龙头代币数量
        if (token.balanceOf(address(this)) < targetAmount) {
            revert JUNFaucet__FaucetNotEnough();
        }
        // 更新用户领取时间
        dripTimes[msg.sender] = block.timestamp;
        // 发送代币
        token.safeTransfer(msg.sender, targetAmount);
        // 触发事件
        emit JUNFaucet__Drip(msg.sender, targetAmount);
    }

    // 定义 deposit 函数，允许合约所有者存入代币。
    function deposit(uint256 _amount) external onlyOwner {
        if (_amount <= 0) {
            revert JUNFaucet__InvalidAmount();
        }
        if (token.balanceOf(msg.sender) < _amount) {
            revert JUNFaucet__InvalidAmount();
        }
        // 存入代币
        token.safeTransferFrom(msg.sender, address(this), _amount);
        // 触发事件
        emit JUNFaucet__OwnerDeposit(_amount);
    }

    //  定义 setDripInterval 函数，允许合约所有者设置新的领取间隔。
    function setDripInterval(uint256 _dripInterval) external onlyOwner {
        dripInterval = _dripInterval;
    }

    // 定义 setDripLimit 函数，允许合约所有者设置新的领取限制。
    function setDripLimit(uint256 _dripLimit) external onlyOwner {
        dripLimit = _dripLimit;
    }

    // 定义 setTokenAddress 函数，允许合约所有者设置新的代币合约地址。
    function setTokenAddress(address _tokenAddress) external onlyOwner {
        tokenAddress = _tokenAddress;
    }

    // 定义 getDripTime 函数，允许合约所有者获取用户上次领取代币的时间。
    function getDripTime(address _user) public view returns (uint256) {
        return dripTimes[_user];
    }

    //定义 getDripInterval 函数，返回当前的领取间隔。
    function getDripInterval() public view returns (uint256) {
        return dripInterval;
    }

    //定义 getDripLimit 函数，返回当前的领取限制。
    function getDripLimit() public view returns (uint256) {
        return dripLimit;
    }
}
